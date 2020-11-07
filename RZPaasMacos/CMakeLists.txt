cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)

project(RZPaas OBJC CXX)


message("${PROJECT_SOURCE_DIR}")
# target_include_directories(RZPaas PUBLIC "${PROJECT_SOURCE_DIR}")

file(GLOB_RECURSE sourceFiles 
"${PROJECT_SOURCE_DIR}/*.h"
"${PROJECT_SOURCE_DIR}/*.m"
"${PROJECT_SOURCE_DIR}/*.mm"
"${PROJECT_SOURCE_DIR}/*.cpp"
)

execute_process(COMMAND xcodebuild -version -sdk macosx Path
    OUTPUT_VARIABLE CMAKE_OSX_SYSROOT_INT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
message("=============${CMAKE_OSX_SYSROOT_INT}")

set(CMAKE_OSX_SYSROOT ${CMAKE_OSX_SYSROOT_INT})

file(GLOB_RECURSE public_headers "${PROJECT_SOURCE_DIR}/*.h")
message(${sourceFiles})

set(frameworks  
"-framework Foundation"
"-framework AVFoundation"
"-framework AppKit"
"-framework CoreVideo"
)


add_library(dynamicFramework SHARED
"${sourceFiles}"
)
target_link_libraries(dynamicFramework ${frameworks})
set_target_properties(dynamicFramework PROPERTIES 
FRAMEWORK TRUE
PUBLIC_HEADER "${public_headers}"
)


