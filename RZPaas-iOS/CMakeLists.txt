cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)

project(RZPaas OBJC CXX)



message("${PROJECT_SOURCE_DIR}")
# target_include_directories(RZPaas PUBLIC "${PROJECT_SOURCE_DIR}")

file(GLOB_RECURSE sourceFiles "${PROJECT_SOURCE_DIR}/*.mm" "${PROJECT_SOURCE_DIR}/*.cpp" "${PROJECT_SOURCE_DIR}/*.h")

file(GLOB_RECURSE public_headers "${PROJECT_SOURCE_DIR}/*.h")
message(${sourceFiles})


set(TARGET_LINK_LIBRARIES  "-framework Foundation")


add_library(dynamicFramework SHARED
"${sourceFiles}"
)
target_link_libraries(dynamicFramework ${TARGET_LINK_LIBRARIES})

set(CODESIGN_EMBEDDED_FRAMEWORKS 0)

set_target_properties(dynamicFramework PROPERTIES 
FRAMEWORK TRUE
PUBLIC_HEADER "${public_headers}"
)


