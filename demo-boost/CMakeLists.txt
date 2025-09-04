
set(exename "Polyfit-Boost-demo")

if(NOT TARGET Boost::headers)
    message(FATAL_ERROR "Boost not found - should be found by parent project")
endif()

add_executable(${exename})

target_link_libraries(${exename} PUBLIC
    Polyfit::Polyfit
    Boost::headers
)

target_sources(${exename} PRIVATE
    main.cpp
)

install(TARGETS ${exename}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
