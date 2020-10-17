#ifndef __MAIN_HPP
#define __MAIN_HPP

#include <string>

/*
	These values should be set within CMakeLists.txt
*/
namespace PROJECT {
	static unsigned int const VERSION_MAJOR{0};
	static unsigned int const VERSION_MINOR{1};
	static unsigned int const VERSION_PATCH{0};
	static std::string const VERSION{"0.1.0"};

	static std::string const PROJECT_NAME{"tileopt"};
	static std::string const PROJECT_CONTACT{"Damian R (damian@sudden-desu.net)"};
	static std::string const PROJECT_WEBSITE{"https://github.com/drojaazu"};
}

void print_help() {
  std::cout << PROJECT::PROJECT_NAME << " - ver. " << PROJECT::VERSION
            << std::endl;
}
#endif
