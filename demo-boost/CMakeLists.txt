cmake_minimum_required(VERSION 3.30)
project(
    "Polyfit-Boost-demo"
    LANGUAGES CXX
    VERSION 7.1.0)

###############
# ASI default settings
list(APPEND CMAKE_MODULE_PATH "$ENV{ASV_CMAKE}")
include(asv_cmake_defaults)
asv_cmake_defaults( )
###############

set(exename "Polyfit-Boost-demo")

include(GNUInstallDirs)

# use our own library - installed 
find_package(Polyfit CONFIG REQUIRED)
find_package(Boost CONFIG REQUIRED COMPONENTS
    headers
    )

add_executable(${exename})
target_link_libraries(${exename} PUBLIC
    Polyfit::Polyfit
    Boost::headers
    )
target_sources(${exename} PRIVATE
    main.cpp
)

install(TARGETS ${exename}
    RUNTIME DESTINATION bin)
