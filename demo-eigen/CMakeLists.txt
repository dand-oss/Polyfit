# This CMakeLists.txt is meant to be included via add_subdirectory()
# from the parent Polyfit project

# No need for project() when used as subdirectory
set(exename "Polyfit-Eigen-demo")

# Dependencies should already be found by parent if POLYFIT_BUILD_DEMOS is ON
# But we can verify they exist
if(NOT TARGET Eigen3::Eigen)
    message(FATAL_ERROR "Eigen3 not found - should be found by parent project")
endif()
if(NOT TARGET Boost::headers)
    message(FATAL_ERROR "Boost not found - should be found by parent project")
endif()

add_executable(${exename})

target_link_libraries(${exename} PUBLIC
    Polyfit::Polyfit
    Eigen3::Eigen
    Boost::headers
)

target_sources(${exename} PRIVATE
    main.cpp
)

# Installation
install(TARGETS ${exename}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
