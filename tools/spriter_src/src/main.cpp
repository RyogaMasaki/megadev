#include <chrgfx/chrgfx.hpp>
#include <filesystem>
#include <fstream>
#include <getopt.h>
#include <iostream>
#include <png++/png.hpp>
#include <vector>

#include "common.hpp"
#include "parse_sprdef.hpp"
#include "project.hpp"
#include "sprite_makechr.hpp"
#include "sprite_maketbl.hpp"
#include "spritedef.hpp"

#include "md_gfx.hpp"

using namespace chrgfx;

struct runtime_config {
	std::string inpng_filepath{""};
	std::string output{""};
	std::string sprdef{""};
	u16 base{0};
	bool make_palette{false};
};

int process_args(runtime_config &cfg, int argc, char **argv);
void print_help();

/*
	This code works, but it's all proof of concept stage
	So definitely room for user friendliness/error checking/optimization/etc
*/
int main(int argc, char **argv)
{

	try {
		runtime_config cfg;
		try {
			// Parse Options & Args
			int process_args_result{process_args(cfg, argc, argv)};
			if(process_args_result < 1) {
				return process_args_result;
			}

			if(cfg.inpng_filepath.empty()) {
				std::cerr << "No input image specified" << std::endl;
				return -1;
			}

			if(cfg.output.empty()) {
				cfg.output = std::filesystem::path(cfg.inpng_filepath).filename();
			}
		} catch(std::exception const &e) {
			std::cerr << "Invalid argument: " << e.what() << std::endl;
			return -5;
		}

		// Main Code Logic
		std::cout << "Processing " << cfg.inpng_filepath << "..." << std::endl;

		png::image<png::index_pixel> in_image;

		in_image.read(cfg.inpng_filepath);

		// width and height of image in tiles
		unsigned int img_width_chr{in_image.get_width() / MD_CHR.get_width()},
				img_height_chr{in_image.get_height() / MD_CHR.get_height()};

		// convert input png into raw CHR tiles
		// note that png_chunk returns tiles in STANDARD format
		// (8bit pixels), not in the chrdef format
		chrbank src_tiles{png_chunk(MD_CHR, in_image.get_pixbuf())};

		size_t tile_count{src_tiles.size()};

		// make sure our tile counts match
		assert(tile_count == (img_width_chr * img_height_chr));

		// read in our spritedefs
		auto sprite_defs{parse_sprdef(cfg.sprdef)};

		// make ordered list of chrs
		auto chr_list{make_chr(src_tiles, sprite_defs, img_width_chr)};

		// write tile data to file
		std::ofstream tile_data_file(std::string(cfg.output + ".chr"));
		for(auto this_tile : chr_list) {
			tile_data_file.write(
					(char *)chrgfx::conv_chr::cvto_chr(MD_CHR, this_tile), 32);
		}
		tile_data_file.close();

		auto spr_list{make_tbl(sprite_defs, cfg.base)};

		std::ofstream tile_map_file(std::string(cfg.output + ".spr"));

		u8 *(*copyfunc)(u8 *, u8 *, u8 *);
		if(chrgfx::bigend_sys) {
			copyfunc = std::copy;
		} else {
			copyfunc = std::reverse_copy;
		}
		size_t out_iter{0};
		u8 temp[2];
		for(auto this_raw_entry : spr_list) {
			copyfunc((u8 *)&this_raw_entry[0], (u8 *)&this_raw_entry[0] + 2, temp);
			tile_map_file.write((char const *)temp, 2);

			copyfunc((u8 *)&this_raw_entry[1], (u8 *)&this_raw_entry[1] + 2, temp);
			tile_map_file.write((char const *)temp, 2);

			copyfunc((u8 *)&this_raw_entry[2], (u8 *)&this_raw_entry[2] + 2, temp);
			tile_map_file.write((char const *)temp, 2);

			copyfunc((u8 *)&this_raw_entry[3], (u8 *)&this_raw_entry[3] + 2, temp);
			tile_map_file.write((char const *)temp, 2);

			++out_iter;
		}
		tile_map_file.close();

		// dump palette if requested
		if(cfg.make_palette) {
			uptr<u8> out_pal{chrgfx::conv_palette::cvto_pal(MD_PAL, MD_COL,
																											in_image.get_palette())};
			std::ofstream tile_palette_file(std::string(cfg.output + ".pal"));
			tile_palette_file.write((char *)out_pal.get(),
															MD_PAL.get_palette_datasize_bytes());
			tile_palette_file.close();
		}

		std::cout << "Tile count: " << std::to_string(chr_list.size()) << std::endl;
		std::cout << "Sprite entries: " << std::to_string(spr_list.size())
							<< std::endl;

	} catch(std::exception const &e) {
		std::cerr << "Fatal Error: " << e.what() << std::endl;
		return -1;
	}

	return 0;
}

int process_args(runtime_config &cfg, int argc, char **argv)
{
	std::vector<option> long_opts{{"image", required_argument, nullptr, 'i'},
																{"sprdef", required_argument, nullptr, 's'},
																{"output", required_argument, nullptr, 'o'},
																{"base", required_argument, nullptr, 'b'},
																{"make-palette", no_argument, nullptr, 'p'},
																{"help", no_argument, nullptr, 'h'}};
	std::string short_opts{":i:o:b:ph"};

	while(true) {
		const auto this_opt =
				getopt_long(argc, argv, short_opts.data(), long_opts.data(), nullptr);
		if(this_opt == -1)
			break;

		switch(this_opt) {
			case 'b':
				cfg.base = std::stoi(optarg) & 0x1fff;
				break;

			case 'i':
				cfg.inpng_filepath = optarg;
				break;

			case 's':
				cfg.sprdef = optarg;
				break;

			case 'o':
				cfg.output = optarg;
				break;

			case 'p':
				cfg.make_palette = true;
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
