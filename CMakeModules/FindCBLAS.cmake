# - Find CBLAS library
#
# This module finds an installed fortran library that implements the CBLAS
# linear-algebra interface (see http://www.netlib.org/blas/)
#
# This module sets the following variables:
#   CBLAS_FOUND - whether CBLAS was found on the system.
#   CBLAS_INCLUDE_DIRS - path to the CBLAS include directory.
#   CBLAS_LIBRARIES - full path to the CBLAS libraries.

# Override variable for non-system installation of CBLAS.
set(CBLAS_ROOT_DIR CACHE STRING
  "Path to the LAPACKE installation directory")

# MKL specific install suffix.
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(MKL_TARGET_ARCH "intel64")
else
  set(MKL_TARGET_ARCH "ia32")
endif ()

# Use pkg-config to provide additional hints if available.
find_package(PkgConfig)
pkg_check_modules(PC_CBLAS QUIET "cblas")

find_path(CBLAS_INCLUDE_DIRS
  NAMES "cblas.h" "mkl_cblas.h"
  HINTS ${CBLAS_ROOT_DIR}
        ${PC_CBLAS_INCLUDE_DIRS}
  PATH_SUFFIXES "include")

find_library(CBLAS_LIBRARY
  NAMES "cblas mkl_rt openblas"
  HINTS ${CBLAS_ROOT_DIR}
        ${PC_CBLAS_LIBRARY_DIRS}
  PATH_SUFFIXES ${MKL_TARGET_ARCH})

# Case where CBLAS is contained in BLAS like for Debian. 
if (NOT CBLAS_LIBRARY AND CBLAS_INCLUDE_DIRS)
  pkg_check_modules(PC_BLAS QUIET "blas")
  find_library(BLAS_LIBRARY  
    NAMES "blas"
    HINTS ${CBLAS_ROOT_DIR}
          ${PC_BLAS_LIBRARY_DIRS})
endif ()

set(CBLAS_LIBRARIES ${CBLAS_LIBRARY} ${BLAS_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LAPACKE DEFAULT_MSG
  LAPACKE_LIBRARIES LAPACKE_INCLUDE_DIR)

mark_as_advanced(BLAS_LIBRARY CBLAS_LIBRARY CBLAS_ROOT_DIR)
