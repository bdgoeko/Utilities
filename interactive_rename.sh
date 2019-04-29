#!/bin/bash

#interactive_rename.sh by Brian Dolan-Goecke is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License
# See http://creativecommons.org/licenses/by-nc/4.0/

# Name: rename.sh
# Description: A script to aid in renameing files

#VERSION="0.1.1-bdg-2012" # New revision control
VERSION="0.0.1-goeko-20150503215341"


function usage() {
  echo "$0 base_file_name [ base_file_name | ... ]"
  echo "This script will help your rename all the files with the base name given"
}

if test $# -ge 1
then
  while test $# -ge 1
  do
    FILE_COUNT=`ls "${1}"* 2>/dev/null | wc -l`
    if test ${FILE_COUNT} -ge 1
    then
      echo "Going to rename files:"
      ls -1 "${1}"* 2>/dev/null
      for f in "${1}"*
      do
#        echo "File: \"${f}\" enter new name:" 
#        echo "Enter new name for \"${f}\":" 
#        echo -e "New Name: \c"
#        echo "New Name:"
        read -p"Enter new name for \"${f}\":" -e -i"${f}" NEW_NAME
        if test "${NEW_NAME}" != "${f}"
        then
          if test -n "${NEW_NAME}"
          then
            if test -f "${NEW_NAME}"
            then
              echo "Error: File \"${NEW_NAME}\" exits, \"${f}\" NOT renamed"
            else
              # echo "mv "${f}" "${NEW_NAME}""
              mv "${f}" "${NEW_NAME}"
              echo "Renamed file \"${f}\" to \"${NEW_NAME}\""
            fi
          else
            echo "Error: unwilling to rename \"${f}\" to \"\""
          fi
        else
          echo "No change to \"${f}\" not renaming"
        fi
      done
    else
      echo "Something bad"
    fi

    echo ""
    shift
  done
else
  echo "Error: No name given"
  usage
  exit 130
fi
