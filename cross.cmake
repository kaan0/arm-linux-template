set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
#set(CMAKE_CXX_STANDARD 11)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

#set(toolchain_path /opt/KernelCache/5.9.3_BBB.kernel)
#set(sysroot_target ${toolchain_path}/tools/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/arm-linux-gnueabihf/libc)
#set(sysroot_target /usr/arm-linux-gnueabihf/)
#set(tools ${toolchain_path}/tools/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/bin)

set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

SET(CMAKE_CXX_FLAGS " -march=armv7-a -marm -mfpu=neon -mfloat-abi=hard" )
SET(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS})

SET(CMAKE_EXE_LINKER_FLAGS " -lpthread")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)