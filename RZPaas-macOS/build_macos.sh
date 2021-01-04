#/bin/sh


rm -rf build

mkdir -p build
cd build 

cmake .. -G Xcode 
cmake --build . --config Release