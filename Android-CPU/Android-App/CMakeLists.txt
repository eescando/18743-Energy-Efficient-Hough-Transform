# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

add_library( # Sets the name of the library.
             native-lib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             src/main/cpp/native-lib.cpp src/main/cpp/HoughTransform.cpp )

#add_library( # Sets the name of the library.
#             HoughTransform

             # Sets the library as a shared library.
#             SHARED

             # Provides a relative path to your source file(s).
 #            src/main/cpp/HoughTransform.cpp )

#include_directories(src/main/cpp/includes/)
include_directories(src/main/cpp/)

#set(BOOST_ROOT libs/boost_1.68.0_prebuilt_ndk_18b/1.68.0)
#set( Boost_INCLUDE_DIR ${BOOST_ROOT}/include )
#set( Boost_LIBRARY_DIR ${BOOST_ROOT}/libs )
#set( Boost_Version 1_68 )

#find_library( Boost ${Boost_Version} COMPONENTS system thread )
#if( Boost_FOUND )
#    target_include_directories( HoughTransform PUBLIC/PRIVATE ${Boost_INCLUDE_DIR} )


    # its possible to include boost to system path too:
    # include_directories( SYSTEM ${Boost_INCLUDE_DIR} )

#    link_directories( ${Boost_LIBRARY_DIR} )
#    target_link_libraries( HoughTransform ${Boost_LIBRARIES} )
#endif()

# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

find_library( # Sets the name of the path variable.
        android-lib

        # Specifies the name of the NDK library that
        # you want CMake to locate.
        android )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       native-lib

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib} ${android-lib} )