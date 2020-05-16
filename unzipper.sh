#!/bin/bash

# a script that will put all filea from a zip into a directory....
#  if the zip already has a directory it will move all into the directory by the zip name and remove the other dir...

VERSION="0.0.1-goeko-20200515133534"

SCRIPT=`basename $0`

function usage {
  echo "Usage: ${SCRIPT} {filename}"
}

echo "$#"
echo "$*"

if test $# -lt 1 ; then
  usage
  exit 130
fi

zipfile=$1

if test ! -f "$1"; then
  if test ! -f "$1.zip"; then
    echo "File '$1' not found!"
    exit 130
  else
    # add zip onto the filename
    zipfile="$1.zip"
  fi
fi

# ok, should like the archive, pull the file names and the parse apart on '/' and see if the first token of every file/line is the same...
# then we would know if the arcive will create a directory or now...
#  arg... 
# but not gonna do that now...

DIRNAME=${zipfile%%.zip}
echo "Directory ${DIRNAME}"

echo "Creating directory"
mkdir "${DIRNAME}"

cd "${DIRNAME}"
echo "Unzipping files"
unzip "../${zipfile}"

FILECNT=`ls -1 | wc -l`

# we have only one directory in the directory we just unzipped into... 
#  ie the zip files were in a directory
if test "${FILECNT}" -eq 1 ; then
  NEW_FILE=`ls -1`
  if test -d "${NEW_FILE}"; then
    echo "Only 1 directory, moving contents up"
    mv "${NEW_FILE}"/* .
    rmdir "${NEW_FILE}"
  fi
fi

echo "Moving zip file ${zipfile} into directory."
# put the zipfile into the directory.... 
#  maybe make this an option 
mv "../${zipfile}" . 

echo "Run Complete"
