#
# Cmake cross compile toolchain for raspberry pi 4 64-bit
#

#Target operating system and architecture
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TARGET_PREFIX aarch64-poky-linux)

#C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#sysroot
set(CMAKE_SYSROOT /opt/poky/3.1.3/sysroots/aarch64-poky-linux)
set(TARGET_SYSROOT /opt/poky/3.1.3/sysroots/aarch64-poky-linux)
set(TARGET_TOOLS_DIR /opt/poky/3.1.3/sysroots/x86_64-pokysdk-linux/usr/bin/${TARGET_PREFIX})

set(CMAKE_C_COMPILER ${TARGET_TOOLS_DIR}/${TARGET_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TARGET_TOOLS_DIR}/${TARGET_PREFIX}-g++)

SET(CMAKE_CXX_FLAGS " -mcpu=cortex-a72+crc+crypto -fstack-protector-strong   -Wformat -Wformat-security -Werror=format-security --sysroot=${TARGET_SYSROOT}" CACHE INTERNAL "" FORCE)
SET(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS} CACHE INTERNAL "" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)