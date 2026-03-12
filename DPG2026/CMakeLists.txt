# CMake configuration
cmake_minimum_required(VERSION 3.24)
project(DPG2026)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../common)

set(SERVER_NAME lustre)
set(FIG_DESTINATION /lustre/r3b/ywang/analysis/jupyter/DPG2026)

include(beamer_init)
