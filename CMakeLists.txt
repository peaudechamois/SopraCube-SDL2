cmake_minimum_required(VERSION 3.21)

project(SopraCube2 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(SopraCube2
    src/main.c
)

# SDL2 (built from local sources)
set(SDL_TEST OFF CACHE BOOL "" FORCE)
set(SDL_TESTS OFF CACHE BOOL "" FORCE)
set(SDL_INSTALL OFF CACHE BOOL "" FORCE)

# Prefer static SDL to avoid needing SDL2.dll at runtime.
set(SDL_SHARED OFF CACHE BOOL "" FORCE)
set(SDL_STATIC ON CACHE BOOL "" FORCE)

if(EXISTS "${CMAKE_SOURCE_DIR}/third_party/SDL2/CMakeLists.txt")
    add_subdirectory(third_party/SDL2 EXCLUDE_FROM_ALL)

    if(TARGET SDL2-static)
        target_link_libraries(SopraCube2 PRIVATE SDL2-static SDL2main)
    elseif(TARGET SDL2)
        target_link_libraries(SopraCube2 PRIVATE SDL2 SDL2main)
    else()
        message(FATAL_ERROR "SDL2 targets not found after add_subdirectory(third_party/SDL2).")
    endif()

    target_include_directories(SopraCube2 PRIVATE
        third_party/SDL2/include
    )
else()
    message(FATAL_ERROR "SDL2 sources not found in third_party/SDL2. Run scripts/fetch_sdl2.ps1 to download them.")
endif()
