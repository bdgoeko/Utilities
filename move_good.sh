#!/bin/bash

#move_good.sh by Brian Dolan-Goecke is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License
# See http://creativecommons.org/licenses/by-nc/4.0/

# Script to move files that are good.

GOOD_COUNT=0
BAD_COUNT=0

PREFIX="/mnt/kerries"

function usage {
  echo "$SCRIPT_NAME Destation_Path_Prefix" 
}

echo "arg cnt $#"

DEST_DIR=.
if test $# -ge 1 ; then
  if test -d "${DEST_DIR}"; then
    DEST_DIR=$1
  else
    echo "${DEST_DIR} is not a dir"
  fi
fi
echo "Destiation Directory Prefix: '${DEST_DIR}'"

# Start reading file from the command line.
while read FILE
do
  good_file=0
  #
  if test -f "${PREFIX}/${FILE}"
  then
    let FILE_CNT++
    FILETYPE=`file -b "${PREFIX}/${FILE}" | cut -d, -f1`
    echo "File Type: '${FILETYPE}'"
    case "${FILETYPE}" in
      [tT][iI][fF][fF]* )
        let GOOD_COUNT++
        good_file=1
        echo "Good PNG image"
      ;;
      [pP][nN][gG]* )
        let GOOD_COUNT++
        good_file=1
        echo "Good PNG image"
      ;;
      [tT][iI][fF]|[fF]* )
        let GOOD_COUNT++
        good_file=1
        echo "Good TIFF image"
      ;;
      [jJ][pP][gG]|[jJ][pP][eE][gG]* )
        let GOOD_COUNT++
        good_file=1
        echo "Good Jpeg image"
      ;;
      [mM][pP][gG]|[jJ][pP][eE][gG]* )
        let GOOD_COUNT++
        good_file=1
        echo "Good Mpeg file"
      ;;
      [aA][uU][dD][iI][oO]" "[Ff][iI][lL][Ee]* )
        let GOOD_COUNT++
        good_file=1
	echo "Good ISO Media File"
      ;;
      [Ii][Ss][Oo]" "[Mm][Ee][Dd][Ii][Aa]* )
        let GOOD_COUNT++
        good_file=1
	echo "Good ISO Media File"
      ;;
      *)
        echo "Unknown file type, not moving.."
	good_file=0
      ;;
    esac
  else
    echo "'${FILE}' is not a file ?"
    let BAD_COUNT++
    EXIT_STATUS=132
  fi

  if test "${good_file}" == 1 ; then
    echo "Copy file '${FILE}'"
    SOURCE_FILE="${PREFIX_DIR}/${FILE}"
    # cut path an file name
    # create desk directory
    # copy file to dest
    #move file
    SOURCE_FILE=`basename "${FILE}"`
    SOURCE_PATH=${FILE%%${SOURCE_FILE}}
    NEW_DEST_DIR="${DEST_DIR}/${SOURCE_PATH}"
    echo "Copy ${PREFIX}/${SOURCE_PATH} to '${DEST_DIR}'/'${SOURCE_PATH}'/'${SOURCE_FILE}'"
    mkdir -p "${DEST_DIR}/${SOURCE_PATH}"
    cp "${PREFIX}/${FILE}" "${DEST_DIR}/${SOURCE_PATH}/"
  else
    echo "Bad file '${FILE}'"
    # Dont move file...
  fi
done # while read file

echo "Good files moved ${GOOD_COUNT} out of ${FILE_CNT} considered"
echo "All done"
exit ${EXIT_STATUS}
