find_package(LATEX COMPONENTS LUALATEX BIBTEX MAKEINDEX)

if(LATEX_FOUND
   AND LATEX_LUALATEX_FOUND
   AND LATEX_BIBTEX_FOUND)
  message(STATUS "Path to lualatex compiler: ${LUALATEX_COMPILER}")
  message(STATUS "Path to bibtex compiler: ${BIBTEX_COMPILER}")
else()
  message(ERROR "No latex compiler is found!")
endif()

if(NOT DEFINED BASE_NAME)
  set(BASE_NAME "main")
endif()

if(NOT DEFINED TEX_COMPILER)
  set(TEX_COMPILER ${LUALATEX_COMPILER})
endif()

if(NOT DEFINED OUT_DIRECTORY)
  set(OUT_DIRECTORY ${CMAKE_BINARY_DIR})
endif()

set(WORKINGDIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(MAIN_TEX "${WORKINGDIR}/${BASE_NAME}.tex")
# set(MAIN_TEX "${OUT_DIRECTORY}/${BASE_NAME}.tex")
set(MAIN_IDX "${OUT_DIRECTORY}/${BASE_NAME}.idx")
set(MAIN_AUX "${OUT_DIRECTORY}/${BASE_NAME}.aux")

# # create symlink:
file(CREATE_LINK "${CMAKE_CURRENT_SOURCE_DIR}/reference.bib"
     "${OUT_DIRECTORY}/reference.bib" SYMBOLIC)

# First pass
add_custom_target(
  latex-prebuild
  COMMAND ${TEX_COMPILER} -output-directory ${OUT_DIRECTORY} -draftmode
          -interaction=nonstopmode ${MAIN_TEX}
  COMMAND ${TEX_COMPILER} -output-directory ${OUT_DIRECTORY} -draftmode
          -interaction=nonstopmode ${MAIN_TEX}
  COMMENT "Starting Prebuild."
  WORKING_DIRECTORY ${WORKINGDIR}
  DEPENDS ${MAIN_TEX})

# Generate the indices for the index table.
add_custom_target(
  latex-makeindex
  COMMAND ${MAKEINDEX_COMPILER} ${MAIN_IDX}
  WORKING_DIRECTORY ${OUT_DIRECTORY}
  COMMENT "Read and create indices with ${MAIN_IDX}."
  DEPENDS ${MAIN_IDX})
add_dependencies(latex-makeindex latex-prebuild)

# Generate what citation found in the latex file.
add_custom_target(
  latex-bibreferences
  COMMAND ${BIBTEX_COMPILER} main.aux
  COMMENT "Read and create main bib references file."
  # WORKING_DIRECTORY ${WORKINGDIR}
  WORKING_DIRECTORY ${OUT_DIRECTORY}
  DEPENDS ${MAIN_AUX})
add_dependencies(latex-bibreferences latex-prebuild)

# Second pass - generate the final pdf.
add_custom_target(
  latex-pdf
  COMMAND ${TEX_COMPILER} -output-directory ${OUT_DIRECTORY} ${MAIN_TEX}
  WORKING_DIRECTORY ${WORKINGDIR}
  COMMENT "Assembling the final pdf file."
  DEPENDS ${MAIN_TEX})

if(EXISTS ${MAIN_IDX})
  add_dependencies(latex-pdf latex-prebuild latex-makeindex latex-bibreferences)
else()
  add_dependencies(latex-pdf latex-prebuild latex-bibreferences)
endif()

add_custom_target(all-formats ALL COMMENT "Starting beamer building.")
add_dependencies(all-formats latex-pdf)
