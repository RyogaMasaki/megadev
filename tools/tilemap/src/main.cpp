/*
 tileopt
  This will take an input PNG and generate Sega Mega Drive format tiles and
 (optionally) palette as well as a tilemap suitable for use in the nametable
*/
#include <getopt.h>
#include <zlib.h>

#include <chrgfx/chrgfx.hpp>
#include <filesystem>
#include <iostream>
#include <optional>
#include <png++/png.hpp>
#include <vector>

#include "chr_utils.hpp"
#include "md_gfx.hpp"
#include "project.hpp"
#include "tileopt.hpp"
#include "tiletypes.hpp"

using namespace chrgfx;

struct runtime_config {
  string inpng_filepath{""};
  string output{""};
  u16 base{0};
  bool make_palette{false};
  bool no_tile_optimize{false};
  bool no_map_optimize{false};
};

bool process_args(runtime_config& cfg, int argc, char** argv);

int main(int argc, char** argv) {
  try {
    runtime_config cfg;
    try {
      // Runtime State Setup
      int process_args_result{process_args(cfg, argc, argv)};
      if (process_args_result < 1) {
        return process_args_result;
      }

      if (cfg.output.empty()) {
        if (cfg.inpng_filepath.empty()) {
          std::cerr << "Must specify an output path if using stdin for input"
                    << std::endl;
          return -1;
        }
        cfg.output = std::filesystem::path(cfg.inpng_filepath).filename();
      }
    } catch (std::exception const& e) {
      std::cerr << "Invalid argument: " << e.what() << std::endl;
      return -5;
    }

    std::cout << "Processing " << cfg.inpng_filepath << "..." << std::endl;

    png::image<png::index_pixel> in_image;

    if (cfg.inpng_filepath.empty()) {
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

    // mark tiles for optimization
    auto optmeta{optimize_tiles(src_tiles)};

    // filter and re-order tiles
    auto final_tiles{make_tile_list(optmeta)};

    // write tile data to file
    std::ofstream tile_data_file(std::string(cfg.output + ".chr"));
    for (auto this_tile : final_tiles) {
      tile_data_file.write((char*)chrgfx::conv_chr::cvto_chr(MD_CHR, this_tile),
                           32);
    }
    tile_data_file.close();

    // dump palette if requested
    if (cfg.make_palette) {
      uptr<u8> out_pal{chrgfx::conv_palette::cvto_pal(MD_PAL, MD_COL,
                                                      in_image.get_palette())};
      std::ofstream tile_palette_file(std::string(cfg.output + ".pal"));
      tile_palette_file.write((char*)out_pal.get(),
                              MD_PAL.get_palette_datasize_bytes());
      tile_palette_file.close();
    }

    // genetate optimized tilemap list
    auto final_tilemap{
        make_tilemap_list(optimize_tilemap(optmeta, cfg.no_map_optimize),
                          cfg.base, img_width_chr)};

    std::ofstream tile_map_file(std::string(cfg.output + ".map"));

    u8* (*copyfunc)(u8*, u8*, u8*);
    if (chrgfx::bigend_sys) {
      copyfunc = std::copy;
    } else {
      copyfunc = std::reverse_copy;
    }
    size_t out_iter{0};
    u8 temp[2];
    for (auto this_raw_entry : final_tilemap) {
      copyfunc((u8*)&this_raw_entry, (u8*)&this_raw_entry + 2, temp);

      tile_map_file.write((char const*)temp, 2);
      ++out_iter;
    }
    tile_map_file.close();

    std::cout << " Input tiles:  " << std::to_string(tile_count) << std::endl;
    std::cout << " Output tiles: " << std::to_string(final_tiles.size())
              << std::endl;

  } catch (std::exception const& e) {
    std::cerr << "Fatal Error: " << e.what() << std::endl;
    return -1;
  }

  return 0;
}

bool process_args(runtime_config& cfg, int argc, char** argv) {
  string short_opts{":i:o:b:phTM"};
  std::vector<option> long_opts{{"image", required_argument, nullptr, 'i'},
                                {"output", required_argument, nullptr, 'o'},
                                {"base", required_argument, nullptr, 'b'},
                                {"make-palette", no_argument, nullptr, 'p'},
                                {"no-map-optimize", no_argument, nullptr, 'M'},
                                {"help", no_argument, nullptr, 'h'}};

  while (true) {
    const auto this_opt =
        getopt_long(argc, argv, short_opts.data(), long_opts.data(), nullptr);
    if (this_opt == -1) break;

    switch (this_opt) {
      case 'b':
        cfg.base = std::stoi(optarg) & 0x1fff;
        break;

      case 'i':
        cfg.inpng_filepath = optarg;
        break;

      case 'o':
        cfg.output = optarg;
        break;

      case 'p':
        cfg.make_palette = true;
        break;

      case 'M':
        cfg.no_map_optimize = true;
        break;

        // help
      case 'h':
        print_help();
        return 0;

      case ':':
        std::cerr << "Missing arg for option: " << std::to_string(optopt)
                  << std::endl;
        return 0;
        break;
      case '?':
        std::cerr << "Unknown argument" << std::endl;
        return -1;
    }
  }

  return 1;
}
