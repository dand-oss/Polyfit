cmake_minimum_required(VERSION 3.31)
project(
    "Polyfit-Boost-demo"
    LANGUAGES CXX
    VERSION 7.1.0)

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
