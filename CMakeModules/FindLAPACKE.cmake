# - Find the LAPACKE library
#
# Usage:
#   find_package(LAPACKE [REQUIRED] [QUIET])
#
# It sets the following variables:
#   LAPACKE_FOUND - whether LAPACKE was found on the system.
#   LAPACKE_INCLUDE_DIRS - path to the LAPACKE include directory.
#   LAPACKE_LIBRARIES - full path to the LAPACKE libraries.

# Override variable for non-system installation of LAPACKE.
set(LAPACKE_ROOT_DIR CACHE STRING
  "Path to the LAPACKE installation directory")

# MKL specific install suffix.
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(MKL_TARGET_ARCH "intel64")
else
  set(MKL_TARGET_ARCH "ia32")
endif ()

# Use pkg-config to provide additional hints if available.
find_package(PkgConfig)
pkg_check_modules(PC_LAPACKE QUIET "lapacke")

find_path(LAPACKE_INCLUDE_DIRS
  NAMES "lapacke.h" "mkl_lapacke.h"
  HINTS ${LAPACKE_ROOT_DIR}
        ${PC_LAPACKE_INCLUDE_DIRS}
  PATH_SUFFIXES "include")

find_library(LAPACK_LIB
  NAMES "lapack lapack_atlas mkl_rt openblas"
  HINTS ${LAPACKE_ROOT_DIR}
        ${PC_LAPACKE_LIBRARY_DIRS}
  PATH_SUFFIXES ${MKL_TARGET_ARCH})

find_library(LAPACKE_LIB
  NAMES "lapacke mkl_rt openblas"
  HINTS ${LAPACKE_ROOT_DIR}
        ${PC_LAPACKE_LIBRARY_DIRS}
  PATH_SUFFIXES ${MKL_TARGET_ARCH})

set(LAPACKE_LIBRARIES ${LAPACK_LIBRARY} ${LAPACKE_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LAPACKE DEFAULT_MSG
  LAPACKE_LIBRARIES LAPACKE_INCLUDE_DIR)

mark_as_advanced(LAPACK_LIBRARY LAPACKE_LIBRARY
  LAPACKE_ROOT_DIR)
