#ifndef SPRITER__PARSE_SPRDEF_HPP
#define SPRITER__PARSE_SPRDEF_HPP

#include "spritedef.hpp"
#include <cerrno>
#include <chrgfx/types.hpp>
#include <fstream>

template <typename T> T sto(std::string const &val, int base = 10)
{
	signed long temp{std::stol(val, nullptr, base)};
	if(temp < std::numeric_limits<T>::min() ||
		 temp > std::numeric_limits<T>::max()) {
		throw std::out_of_range("Value does not fit in specified type");
	}
	return (T)temp;
}

/**
 * Converts a comma delimited list of integer values into a vector
 */
template <typename T> std::vector<T> vd_int_array(std::string const &val)
{
	std::vector<T> out;

	std::istringstream ss{val};
	std::string this_value;

	while(std::getline(ss, this_value, ',')) {
		out.push_back(sto<T>(this_value));
	}
	return out;
}

vector<SpriteDef> parse_sprdef(std::string const &def_file)
{
	std::ifstream in{def_file};
	if(!in.good()) {
		throw std::ios_base::failure(std::strerror(errno));
	}

	in.seekg(std::ios::beg);

	std::string this_line{};
	vector<SpriteDef> out;

	while(std::getline(in, this_line)) {
		try {
			auto this_values{vd_int_array<unsigned int>(this_line)};
			SpriteDef tempdef;
			tempdef.SourceTileX = this_values[0];
			tempdef.SourceTileY = this_values[1];
			tempdef.SpriteWidth = this_values[2];
			tempdef.SpriteHeight = this_values[3];
			tempdef.Next = this_values[4];
			out.push_back(tempdef);
		} catch(std::exception const &e) {
			std::cerr << "Failed to parse sprite definition: " << this_line
								<< std::endl;

			continue;
		}
	}

	return out;
}

#endif
