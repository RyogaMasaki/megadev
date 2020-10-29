include(CheckIncludeFiles)
include(GNUInstallDirs)

# define project
cmake_minimum_required (VERSION 3.5)
project (makefont VERSION 1.0.0 LANGUAGES CXX)
set(PROJECT_CONTACT "Damian R (damian@sudden-desu.net)")
set(PROJECT_WEBSITE "https://github.com/drojaazu")

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/src/project.hpp.cfg" "${CMAKE_CURRENT_SOURCE_DIR}/src/project.hpp")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_COMPILER_NAMES clang++ g++ icpc c++ cxx)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG")

find_library(PNG_LIB png)
if(NOT PNG_LIB)
  message(FATAL_ERROR "libpng not found")
endif()

check_include_files("png++/png.hpp" PNGPP_H)
if(NOT PNGPP_H)
  message(FATAL_ERROR "png++ not found")
endif()

find_library(CHRGFX_LIB chrgfx)
if(NOT CHRGFX_LIB)
  message(FATAL_ERROR "libchrgfx not found")
endif()

if (NOT EXISTS ${CMAKE_BINARY_DIR}/CMakeCache.txt)
  if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
  endif()
endif()

aux_source_directory("${CMAKE_CURRENT_SOURCE_DIR}/src" SRCFILES)
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/inc")



add_executable(${PROJECT_NAME} ${SRCFILES})

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_17)
target_link_libraries(${PROJECT_NAME} png chrgfx)
