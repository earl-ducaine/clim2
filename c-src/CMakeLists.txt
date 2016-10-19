
# add_definitions(-DSTDC_HEADERS)
# add_definitions(-DHAVE_REGEX_H)
# add_definitions(-DHAVE_SYS_WAIT_H)
# add_definitions(-DM4=m4)
# add_definitions(-DHAVE_LIMITS_H)

cmake_minimum_required(VERSION 2.8.9)
project(motif_wrapper)
find_package(Motif REQUIRED)
find_package(X11 REQUIRED)

# climxm.so
set(CMAKE_BUILD_TYPE Release)

#Bring the headers, such as Student.h into the project
include_directories(./misc)

# file(GLOB...) allows for wildcard additions:
file(GLOB LIB_SOURCES misc/xmsupport.c misc/xtsupport.c xlib/xlibsupport.c)

#Generate the shared library from the sources
add_library(lib_motif_wrapper SHARED ${LIB_SOURCES})



# TKLIB=-lXm -lXpm -lXext
# XTLIB=-lXt
# XLIB=-lX11
# THREADLIB = -lpthread
# set_target_properties(foo PROPERTIES OUTPUT_NAME "foobar")

target_link_libraries(lib_motif_wrapper ${MOTIF_LIBRARIES} ${X11_LIBRARIES} pthread)

# Set the location for library installation -- i.e., /usr/lib in this case
# not really necessary in this example. Use "sudo make install" to apply
install(TARGETS lib_motif_wrapper DESTINATION /usr/lib)
