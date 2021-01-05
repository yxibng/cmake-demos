cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 11)

project(RZPaas)


message("${PROJECT_SOURCE_DIR}")
# target_include_directories(RZPaas PUBLIC "${PROJECT_SOURCE_DIR}")

file(GLOB_RECURSE sourceFiles 
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

set(CMAKE_OSX_ARCHITECTURES x86_64)
message("=============${CMAKE_OSX_ARCHITECTURES}")


file(GLOB_RECURSE public_headers "${PROJECT_SOURCE_DIR}/RZPaas.h")

file(GLOB_RECURSE all_headers "${PROJECT_SOURCE_DIR}/*.h")


message(${sourceFiles})

set(frameworks  
"-framework Foundation"
"-framework AVFoundation"
"-framework AppKit"
"-framework CoreVideo"
"-framework CoreMedia"
)

set(CMAKE_OSX_DEPLOYMENT_TARGET "10.12")
add_library(dynamicFramework SHARED
${sourceFiles}
${public_headers}
)

target_include_directories(dynamicFramework PUBLIC "${PROJECT_SOURCE_DIR}")
target_link_libraries(dynamicFramework ${frameworks})

set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "")


set_target_properties(dynamicFramework PROPERTIES 

    CXX_VISIBILITY_PRESET default

    FRAMEWORK TRUE
    PUBLIC_HEADER "${public_headers}"
    FRAMEWORK_VERSION A
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.sdk.macos"
    XCODE_ATTRIBUTE_MARKETING_VERSION 1.0.0
    XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION 1
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    XCODE_ATTRIBUTE_DEFINES_MODULE YES
    XCODE_ATTRIBUTE_MODULEMAP_FILE ${CMAKE_CURRENT_SOURCE_DIR}/module.modulemap
)
set_property (TARGET dynamicFramework APPEND_STRING PROPERTY 
              COMPILE_FLAGS "-fobjc-arc")


     