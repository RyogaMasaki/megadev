#include <chrgfx/chrgfx.hpp>
#include <filesystem>
#include <fstream>
#include <getopt.h>
#include <iostream>
#include <vector>

#include "common.hpp"
#include "md_gfx.hpp"
#include "project.hpp"

using namespace chrgfx;

int process_args(int argc, char **argv);
void print_help();

struct runtime_config {
	std::string inpng_filepath{""};
	std::string output{""};

} cfg;

int main(int argc, char **argv)
{
	try {
		// Parse Options & Args
		int process_args_result{process_args(argc, argv)};
		if(process_args_result < 1) {
			return process_args_result;
		}

		// Runtime Config Setup
		if(cfg.output.empty()) {
			if(cfg.inpng_filepath.empty()) {
				std::cerr << "Must specify an output path if using stdin for input"
									<< std::endl;
				return -1;
			}
			cfg.output = std::filesystem::path(cfg.inpng_filepath).filename();
		}

		// Main Code Logic
		std::cout << "Processing " << cfg.inpng_filepath << "..." << std::endl;

		png::image<png::index_pixel> in_image;

		if(cfg.inpng_filepath.empty()) {
			in_image.read_stream(std::cin);
		} else {
			in_image.read(cfg.inpng_filepath);
		}

		// width and height of image in tiles
		uint img_width_chr{in_image.get_width() / MD_CHR.get_width()},
				img_height_chr{in_image.get_height() / MD_CHR.get_height()};

		// convert input png into raw CHR tiles
		// note that png_chunk returns tiles in STANDARD format
		// (8bit pixels), not in the chrdef format
		chrbank src_tiles{png_chunk(MD_CHR, in_image.get_pixbuf())};

		size_t tile_count{src_tiles.size()};

		// make sure our tile counts match
		assert(tile_count == (img_width_chr * img_height_chr));

		// we might make this tool more useful in the future
		// for now, we're just using it for 8x16 fonts
		std::vector<u8 *> ordered_chrs;

		for(size_t row{0}; row < img_height_chr; row += 2) {
			for(int col{0}; col < img_width_chr; ++col) {
				size_t upper_tile = (row * img_width_chr) + col;
				size_t lower_tile = ((row + 1) * img_width_chr) + col;
				ordered_chrs.push_back(src_tiles.at(upper_tile).get());
				ordered_chrs.push_back(src_tiles.at(lower_tile).get());
			}
		}

		std::ofstream tile_data_file(std::string(cfg.output + ".chr"));
		for(auto this_tile : ordered_chrs) {
			tile_data_file.write(
					(char *)chrgfx::conv_chr::cvto_chr(MD_CHR, this_tile), 32);
		}

	} catch(std::exception const &e) {
		std::cerr << "Fatal Error: " << e.what() << std::endl;
		return -1;
	}

	return 0;
}

int process_args(int argc, char **argv)
{
	std::vector<option> long_opts{{"image", required_argument, nullptr, 'i'},
																{"output", required_argument, nullptr, 'o'},
																{"help", no_argument, nullptr, 'h'}};
	std::string short_opts{":i:o:O:P:Th"};

	while(true) {
		const auto this_opt =
				getopt_long(argc, argv, short_opts.data(), long_opts.data(), nullptr);
		if(this_opt == -1)
			break;

		switch(this_opt) {
				// infile
			case 'i':
				cfg.inpng_filepath = optarg;
				break;

			// outfile
			case 'o':
				cfg.output = optarg;
				break;

			// help
			case 'h':
				print_help();
				return 0;

			case ':':
				std::cerr << "Missing argument for option " << std::to_string(optopt)
									<< std::endl;
				return 0;
				break;
			case '?':
				std::cerr << "Unknown option" << std::endl;
				return -1;
		}
	}
	return 1;
}

void print_help()
{
	std::cout << PROJECT::PROJECT_NAME << " - ver. " << PROJECT::VERSION
						<< std::endl;
}
