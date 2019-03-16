#!/bin/bash

# script to see if a file exists in a path.


#PICTURES_PATH=${HOME}/Pictures:${HOME}/pictures
PICTURES_PATH=${HOME}/Pictures:${HOME}/pictures
PICTURES_PATH="/srv/network/Media/:${HOME}/Pictures"
LOOK_DIRS="/srv/network/Media/
${HOME}/Pictures"
LOOK_DIRS="/srv/network/Personal/"

EXIT_STATUS=0 # Hope things will end well

SCRIPT_NAME=`basename $0`

function usage {
    echo "usage: $SCRIPT_NAME file {file file file ...}"
}

# make sure we got some option
if test "$#" -le 1; then
    echo "no options given"
    usage
    exit 130
fi

#build list of like files
FILEFILES="/tmp/allfiless.$$"
ERROR_FILE="/tmp/allfiles_errors.$$"

# look for files
while test $# -gt 0
do
  ORIG_FILE="${1}"
  # empty our temp file
  > "${FILEFILES}"

  if test -f "${1}" ; then
  
    echo "${LOOK_DIRS}" | while read DIR
    do
      echo "Building list of files from ${DIR}"
      echo "Building list of files from ${DIR}" >> "${ERROR_FILE}"
      find "${DIR}" -depth -print | grep -i "${ORIG_FILE}" >> "${FILEFILES}" 2>> "${ERROR_FILE}"
    done

    if test -f "${FILEFILES}" ; then
      # see if we find any matches..
      LINE_CNT=`wc -l "${FILEFILES}" | cut -d\  -f1`
    else
      LINE_CNT=0
    fi

    if test "${LINE_CNT}" -ge 1 ; then
      echo "Found ${LINE_CNT} file name matches" 
      cat "${FILEFILES}"
    fi

    # build md5sum for orig file
    FILE_MD5SUM=`md5sum ${ORIG_FILE} | cut -d\  -f1`
    echo "File '${ORIG_FILE}' md5sum '${FILE_MD5SUM}'"

    # build md5sum for other files...
    cat "${FILEFILES}" | while read AFILE
    do
      # see which ones match
      AFILE_MD5SUM=`md5sum "${AFILE}" | cut -d\  -f1`
      if test "${AFILE_MD5SUM}" == "${FILE_MD5SUM}" ; then
        echo "Match Found '${AFILE}' matches md5sum '${AFILE_MD5SUM}'"
      fi
    done
  
    # ? then what ? 
    # present report of what we found  ? 

  echo "Possible other files for ${ORIG_FILE}"
  else
    echo "Source '${1}' is not a file"
  fi
  
  # Move to the next file
  shift
done # end of look for multiple files

# nuke temp file
rm -rf "${FILESFILE}"

exit ${EXIT_STATUS}
