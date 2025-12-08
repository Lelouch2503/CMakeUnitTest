cmake_minimum_required(VERSION 3.22)

project(
    CppProjectTemplate
    VERSION 1.0.0
    LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/")

# Enable CPM
option(USE_CPM "Whether to use CPM for dependency management" OFF)
option(USE_CONAN "Whether to use Conan for dependency management" ON)

# Enable Warnings
option(ENABLE_TESTING "Enable a Unit Testing Build" ON)
option(ENABLE_WARNINGS "Enable warnings" ON)
option(ENABLED_AS_ERRORS "Enable warnings as errors" ON)

# Enable Sanitizers
option(ENABLE_SANITIZER_ADDR "Enable " ON)
option(ENABLED_SANITIZER_UNDEF "Enable " ON)

# Enable LTO
option(ENABLED_LTO "Enable LTO" ON)

if(ENABLE_WARNINGS)
    include(Warnings)
endif()

if(ENABLED_LTO)
    include(LTO)
endif()

if(ENABLE_SANITIZER_ADDR OR ENABLED_SANITIZER_UNDEF)
    include(Sanitizers)
    add_sanitizer_flags()
endif()

set(LIBRARY_NAME "Library")
set(EXECUTABLE_NAME "Executable")


include(AddGitSubmodule)
include(FetchContent)
include(Docs)

if(${USE_CPM})
    include(CPM)
    message(STATUS "Using CPM")
    CPMAddPackage("gh:nlohmann/json@3.11.3")
    CPMAddPackage("gh:fmtlib/fmt#9.1.0")
    CPMAddPackage("gh:gabime/spdlog@1.13.0")
    CPMAddPackage("gh:jarro2783/cxxopts@3.1.1")
    CPMAddPackage("gh:nlohmann/json@3.11.3")
elseif(${USE_CONAN})
    message(STATUS "Using Conan")
    include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
    find_package(nlohmann_json REQUIRED)
    find_package(fmt)
    find_package(spdlog)
    find_package(cxxopts)
    find_package(Catch2)
else()
    message(STATUS "Using FetchContent")
    FetchContent_Declare(
        nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json
        GIT_TAG v3.11.3
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(nlohmann_json)

    FetchContent_Declare(
        fmt
        GIT_REPOSITORY https://github.com/fmtlib/fmt
        GIT_TAG 9.1.0
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(fmt)

    FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog
        GIT_TAG v1.13.0
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(spdlog)

    FetchContent_Declare(
        cxxopts
        GIT_REPOSITORY https://github.com/jarro2783/cxxopts
        GIT_TAG v3.1.1
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(cxxopts)
endif()

if(ENABLE_TESTING)
    FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2
        GIT_TAG v3.5.3
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(Catch2)
    list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
endif()

add_subdirectory(configured)
add_subdirectory(external)
add_subdirectory(src)
add_subdirectory(app)

if(ENABLE_TESTING)
    include(CTest)
    enable_testing()
    add_subdirectory(tests)
endif()

if(${ENABLED_LTO})
    target_enable_lto(${LIBRARY_NAME} TRUE)
endif()
