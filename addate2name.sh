#!/bin/bash

#addate2name.sh by Brian Dolan-Goecke is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License
# See http://creativecommons.org/licenses/by-nc/4.0/

EXIT_STATUS=0

find . -depth -print | while read FILE
do 
  if test -f "${FILE}" 
  then
    echo "File '${FILE}'"
    FILENAME=`basename ${FILE}`
    FINFO=`ls --full-time ${FILE} `
    FDATE=`echo ${FINFO} | cut -d\  -f6 | tr -d \- `
    FTEMP=`echo ${FINFO} | cut -d\  -f7 | tr -d \: `
    FTIME=${FTEMP:0:6}
    echo "new file name '${FDATE}${FTIME}-${FILENAME}'"
  else
    echo "${FILE} not a file"
  fi
done

echo "Run Complete"
exit "${EXIT_STATUS}"
