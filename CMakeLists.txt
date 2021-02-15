cmake_minimum_required (VERSION 3.8)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/scripts/.data/project_name.txt")
    file(STRINGS "scripts/.data/project_name.txt" PROJECT_NAME)
    if(${PROJECT_NAME} STREQUAL "")
        message(FATAL_ERROR  "project name failure please run setup_environment.sh")
    else()
        message("project name set to ${PROJECT_NAME}")
    endif()
else()
    message(FATAL_ERROR  "please run setup_environment.sh")
endif()
 

project (${PROJECT_NAME} VERSION 1.0.0)

INCLUDE_DIRECTORIES( "/usr/arm-linux-gnueabihf/include/",
                        "${CMAKE_SOURCE_DIR}/include")

# Add link directories for precompiled libraries
# Prebuilt standart C/C++ libraries can be linked from the cross.cmake file via linker flags. 
# LINK_DIRECTORIES("/home/kaan/opt/boost/lib/")

# Add source to this project's executable.
add_executable (${PROJECT_NAME} "src/main.cpp" "include/main.h")

# TODO: Add tests and install targets if needed.
set(TARGET_BINARY ${PROJECT_NAME})

#Custom target for Only Building
add_custom_target(build ALL)

#Custom target for build and debug with GDB
add_custom_target(build_and_debug ALL)

