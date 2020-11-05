# cmake-demos

参考：https://github.com/leetal/ios-cmake

1. 编写CMakeLists.txt
2. 执行cmake
3. 生成iOS动态库Framework
  ```
  #/bin/sh
  mkdir -p build
  cd build 
  cmake .. -G Xcode -DCMAKE_TOOLCHAIN_FILE=../ios.toolchain.cmake -DPLATFORM=OS64COMBINED
  cmake --build . --config Release
  ```
 
- Set -DPLATFORM to "SIMULATOR" to build for iOS simulator 32 bit (i386) DEPRECATED
- Set -DPLATFORM to "SIMULATOR64" (example above) to build for iOS simulator 64 bit (x86_64)
- Set -DPLATFORM to "OS" to build for Device (armv7, armv7s, arm64)
- Set -DPLATFORM to "OS64" to build for Device (arm64)
- Set -DPLATFORM to "OS64COMBINED" to build for Device & Simulator (FAT lib) (arm64, x86_64)
- Set -DPLATFORM to "TVOS" to build for tvOS (arm64)
- Set -DPLATFORM to "TVOSCOMBINED" to build for tvOS & Simulator (arm64, x86_64)
- Set -DPLATFORM to "SIMULATOR_TVOS" to build for tvOS Simulator (x86_64)
- Set -DPLATFORM to "WATCHOS" to build for watchOS (armv7k, arm64_32)
- Set -DPLATFORM to "WATCHOSCOMBINED" to build for watchOS & Simulator (armv7k, arm64_32, i386)
- Set -DPLATFORM to "SIMULATOR_WATCHOS" to build for watchOS Simulator (i386)
