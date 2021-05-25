project(yogacore)
cmake_minimum_required(VERSION 3.4.1)
set(CMAKE_VERBOSE_MAKEFILE on)

add_compile_options(
    -fno-omit-frame-pointer
    -fexceptions
    -fvisibility=hidden
    -ffunction-sections
    -fdata-sections
    -Wall
    -std=c++11)

file(GLOB_RECURSE yogacore_SRC ../../yoga/*.cpp)
add_library(yogacore SHARED ${yogacore_SRC})

target_include_directories(yogacore PUBLIC .)
target_link_libraries(yogacore android log)
set_target_properties(yogacore PROPERTIES CXX_STANDARD 11)
