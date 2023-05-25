if(NOT CMAKE_CROSSCOMPILING)
  find_package(PkgConfig QUIET)
  pkg_check_modules(PC_AVCODEC libavcodec)
  pkg_check_modules(PC_AVFORMAT libavformat)
  pkg_check_modules(PC_AVUTIL libavutil)
  pkg_check_modules(PC_SWSCALE libswscale)
  pkg_check_modules(PC_SWRESAMPLE libswresample)
  if(TARGET_OS STREQUAL "linux")
    pkg_search_module(PC_X264 libx264 x264)
  endif()
endif()

set_extra_dirs_lib(FFMPEG ffmpeg)
find_library(AVCODEC_LIBRARY
  NAMES avcodec.60 avcodec libavcodec
  HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_AVCODEC_LIBRARY_DIRS}
  PATHS ${PATHS_AVCODEC_LIBDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

find_library(AVFORMAT_LIBRARY
  NAMES avformat.60 avformat libavformat
  HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_AVFORMAT_LIBRARY_DIRS}
  PATHS ${PATHS_AVFORMAT_LIBDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

find_library(AVUTIL_LIBRARY
  NAMES avutil.58 avutil libavutil
  HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_AVUTIL_LIBRARY_DIRS}
  PATHS ${PATHS_AVUTIL_LIBDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

find_library(SWSCALE_LIBRARY
  NAMES swscale.7 swscale libswscale
  HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_SWSCALE_LIBRARY_DIRS}
  PATHS ${PATHS_SWSCALE_LIBDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

find_library(SWRESAMPLE_LIBRARY
  NAMES swresample.4 swresample libswresample
  HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_SWRESAMPLE_LIBRARY_DIRS}
  PATHS ${PATHS_SWRESAMPLE_LIBDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

if(TARGET_OS STREQUAL "linux")
  find_library(X264_LIBRARY
    NAMES x264 libx264
    HINTS ${HINTS_FFMPEG_LIBDIR} ${PC_X264_LIBRARY_DIRS}
    PATHS ${PATHS_X264_LIBDIR}
    ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
  )
endif()

set_extra_dirs_include(AVCODEC ffmpeg "${AVCODEC_LIBRARY}")
find_path(AVCODEC_INCLUDEDIR libavcodec
  HINTS ${HINTS_AVCODEC_INCLUDEDIR} ${PC_AVCODEC_INCLUDE_DIRS}
  PATHS ${PATHS_AVCODEC_INCLUDEDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

set_extra_dirs_include(AVFORMAT ffmpeg "${AVFORMAT_LIBRARY}")
find_path(AVFORMAT_INCLUDEDIR libavformat
  HINTS ${HINTS_AVFORMAT_INCLUDEDIR} ${PC_AVFORMAT_INCLUDE_DIRS}
  PATHS ${PATHS_AVFORMAT_INCLUDEDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

set_extra_dirs_include(AVUTIL ffmpeg "${AVUTIL_LIBRARY}")
find_path(AVUTIL_INCLUDEDIR libavutil
  HINTS ${HINTS_AVUTIL_INCLUDEDIR} ${PC_AVUTIL_INCLUDE_DIRS}
  PATHS ${PATHS_AVUTIL_INCLUDEDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

set_extra_dirs_include(SWSCALE ffmpeg "${SWSCALE_LIBRARY}")
find_path(SWSCALE_INCLUDEDIR libswscale
  HINTS ${HINTS_SWSCALE_INCLUDEDIR} ${PC_SWSCALE_INCLUDE_DIRS}
  PATHS ${PATHS_SWSCALE_INCLUDEDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

set_extra_dirs_include(SWRESAMPLE ffmpeg "${SWRESAMPLE_LIBRARY}")
find_path(SWRESAMPLE_INCLUDEDIR libswresample
  HINTS ${HINTS_SWRESAMPLE_INCLUDEDIR} ${PC_SWRESAMPLE_INCLUDE_DIRS}
  PATHS ${PATHS_SWRESAMPLE_INCLUDEDIR}
  ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

if(TARGET_OS STREQUAL "linux")
  set_extra_dirs_include(X264 x264 "${X264_LIBRARY}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FFMPEG DEFAULT_MSG
  AVCODEC_LIBRARY
  AVFORMAT_LIBRARY
  AVUTIL_LIBRARY
  SWSCALE_LIBRARY
  SWRESAMPLE_LIBRARY
  AVCODEC_INCLUDEDIR
  AVFORMAT_INCLUDEDIR
  AVUTIL_INCLUDEDIR
  SWSCALE_INCLUDEDIR
  SWRESAMPLE_INCLUDEDIR
)

mark_as_advanced(
  AVCODEC_LIBRARY
  AVFORMAT_LIBRARY
  AVUTIL_LIBRARY
  SWSCALE_LIBRARY
  SWRESAMPLE_LIBRARY
  AVCODEC_INCLUDEDIR
  AVFORMAT_INCLUDEDIR
  AVUTIL_INCLUDEDIR
  SWSCALE_INCLUDEDIR
  SWRESAMPLE_INCLUDEDIR
)

set(FFMPEG_LIBRARIES
  ${AVFORMAT_LIBRARY} # has to come before avcodec
  ${AVCODEC_LIBRARY}
  ${AVUTIL_LIBRARY}
  ${SWSCALE_LIBRARY}
  ${SWRESAMPLE_LIBRARY}
)

if(TARGET_OS STREQUAL "linux")
  list(APPEND FFMPEG_LIBRARIES ${X264_LIBRARY})
endif()

if(NOT TARGET_OS STREQUAL "windows")
  list(APPEND FFMPEG_LIBRARIES ${CMAKE_DL_LIBS})
endif()

set(FFMPEG_INCLUDE_DIRS
  ${AVCODEC_INCLUDEDIR}
  ${AVFORMAT_INCLUDEDIR}
  ${AVUTIL_INCLUDEDIR}
  ${SWSCALE_INCLUDEDIR}
  ${SWRESAMPLE_INCLUDEDIR}
)

is_bundled(FFMPEG_BUNDLED "${AVCODEC_LIBRARY}")
set(FFMPEG_COPY_FILES)
if(FFMPEG_BUNDLED)
  if(TARGET_OS STREQUAL "windows")
    set(FFMPEG_COPY_FILES
      "${EXTRA_FFMPEG_LIBDIR}/avcodec-60.dll"
      "${EXTRA_FFMPEG_LIBDIR}/avformat-60.dll"
      "${EXTRA_FFMPEG_LIBDIR}/avutil-58.dll"
      "${EXTRA_FFMPEG_LIBDIR}/swresample-4.dll"
      "${EXTRA_FFMPEG_LIBDIR}/swscale-7.dll"
    )
  elseif(TARGET_OS STREQUAL "mac")
    set(FFMPEG_COPY_FILES
      "${EXTRA_FFMPEG_LIBDIR}/libavcodec.60.dylib"
      "${EXTRA_FFMPEG_LIBDIR}/libavformat.60.dylib"
      "${EXTRA_FFMPEG_LIBDIR}/libavutil.58.dylib"
      "${EXTRA_FFMPEG_LIBDIR}/libswresample.4.dylib"
      "${EXTRA_FFMPEG_LIBDIR}/libswscale.7.dylib"
    )
  endif()
endif()
