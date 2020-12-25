cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)

project(RZPaas)


macro (set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE)
    set_property (TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY} ${XCODE_VALUE})
endmacro (set_xcode_property)

message("${PROJECT_SOURCE_DIR}")
# target_include_directories(RZPaas PUBLIC "${PROJECT_SOURCE_DIR}")

file(GLOB_RECURSE sourceFiles "${PROJECT_SOURCE_DIR}/*.mm" "${PROJECT_SOURCE_DIR}/*.cpp" "${PROJECT_SOURCE_DIR}/*.h")

file(GLOB_RECURSE public_headers "${PROJECT_SOURCE_DIR}/*.h")
message(${sourceFiles})


set(TARGET_LINK_LIBRARIES  "-framework Foundation")


add_library(dynamicFramework SHARED
"${sourceFiles}"
)
# target_link_libraries(dynamicFramework ${TARGET_LINK_LIBRARIES})

SET(CMAKE_XCODE_ATTRIBUTE_SKIP_INSTALL "YES")

# 参考 https://github.com/grimfang4/sdl-gpu/blob/master/scripts/ios-cmake/toolchain/XcodeDefaults.cmake
set_xcode_property(dynamicFramework GCC_GENERATE_DEBUGGING_SYMBOLS[variant=Debug] YES)
set_xcode_property(dynamicFramework GCC_GENERATE_DEBUGGING_SYMBOLS[variant=MinSizeRel] YES)
set_xcode_property(dynamicFramework GCC_GENERATE_DEBUGGING_SYMBOLS[variant=RelWithDebInfo] YES)
set_xcode_property(dynamicFramework GCC_GENERATE_DEBUGGING_SYMBOLS[variant=Release] YES)


set(CODESIGN_EMBEDDED_FRAMEWORKS 0)

set_target_properties(dynamicFramework PROPERTIES 
FRAMEWORK TRUE
PUBLIC_HEADER "${public_headers}"
)


