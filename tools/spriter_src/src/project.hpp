#ifndef __MAIN_HPP
#define __MAIN_HPP

#include <string>

/*
	These values should be set within CMakeLists.txt
*/
namespace PROJECT {
	static unsigned int const VERSION_MAJOR{1};
	static unsigned int const VERSION_MINOR{0};
	static unsigned int const VERSION_PATCH{0};
	static std::string const VERSION{"1.0.0"};

	static std::string const PROJECT_NAME{"spriter"};
	static std::string const PROJECT_CONTACT{"Damian R (damian@sudden-desu.net)"};
	static std::string const PROJECT_WEBSITE{"https://github.com/drojaazu"};
}
#endif
