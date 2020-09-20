cmake_minimum_required(VERSION 3.30)

project(
    "Polyfit"
    LANGUAGES CXX
    VERSION 7.1.0
    DESCRIPTION "C++ implementation of polyfit, with optional weighting like in numpy. Two implementations, one with boost/ublas lib, and one with the Eigen lib."
    HOMEPAGE_URL "https://github.com/dand-oss/Polyfit"
)

set(libname "Polyfit")

# Option to build demos
option(POLYFIT_BUILD_DEMOS "Build demonstration programs" OFF)

include(GNUInstallDirs)

# -----------------------
# Public header list
# -----------------------
set(public_headers
    PolyfitBoost.hpp
    PolyfitEigen.hpp
)

# -----------------------
# Main interface library
# -----------------------
add_library(${libname} INTERFACE)
# add alias so the project can be used with add_subdirectory
add_library(${libname}::${libname} ALIAS ${libname})

# Use file sets for public headers
target_sources(${libname} INTERFACE
    FILE_SET HEADERS
    BASE_DIRS .
    FILES ${public_headers}
)

target_include_directories(
    ${libname}
    INTERFACE 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_features(${libname} INTERFACE cxx_std_11)

# -----------------------
# Demo executables (optional)
# -----------------------
if(POLYFIT_BUILD_DEMOS)
    # Find dependencies for demos
    find_package(Eigen3 CONFIG REQUIRED)
    
    # Find boost
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        Set(Boost_COMPILER "-clang50")
    endif()
    if(NOT BOOST_ROOT)
        set(BOOST_ROOT $ENV{BOOST_ROOT} CACHE PATH "Boost Root Directory")
    endif(NOT BOOST_ROOT)
    set(Boost_NO_SYSTEM_PATHS ON)
    if(USE_STATIC_BOOST)
        set(Boost_USE_STATIC_LIBS ON)
    else()
        set(Boost_USE_STATIC_LIBS OFF)
        add_definitions("-DBOOST_ALL_DYN_LINK")
    endif()
    set(Boost_USE_MULTITHREADED ON)
    
    # Try CONFIG mode first, fallback to module mode
    find_package(Boost CONFIG QUIET COMPONENTS headers)
    if(NOT Boost_FOUND)
        find_package(Boost 1.78.0 EXACT REQUIRED COMPONENTS headers)
    endif()

    # Boost demo
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/demo-boost/main.cpp")
        add_executable(Polyfit-Boost-demo demo-boost/main.cpp)
        target_link_libraries(Polyfit-Boost-demo PUBLIC
            ${libname}::${libname}
            Boost::headers
        )
        install(TARGETS Polyfit-Boost-demo
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    endif()

    # Eigen demo
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/demo-eigen/main.cpp")
        add_executable(Polyfit-Eigen-demo demo-eigen/main.cpp)
        target_link_libraries(Polyfit-Eigen-demo PUBLIC
            ${libname}::${libname}
            Eigen3::Eigen
            Boost::headers
        )
        install(TARGETS Polyfit-Eigen-demo
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    endif()
endif()

# -----------------------
# Install library and headers
# -----------------------
install(TARGETS ${libname}
    EXPORT ${libname}_Targets
    FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(EXPORT ${libname}_Targets
    FILE ${libname}Targets.cmake
    NAMESPACE ${libname}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${libname}
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${libname}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/cmake/${libname}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${libname}Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${libname}
)

install(FILES 
    "${CMAKE_CURRENT_BINARY_DIR}/${libname}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${libname}ConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${libname}
)

# -----------------------
# CPack configuration
# -----------------------
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VENDOR "dand-oss")
set(CPACK_PACKAGE_HOMEPAGE_URL "${PROJECT_HOMEPAGE_URL}")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_GENERATOR "ZIP;TGZ")
include(CPack)