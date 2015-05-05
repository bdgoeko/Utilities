#!/bin/bash

LOGFILE=/tmp/tell_time.log
LOGGEDN=false
THEUSER=""

# --socket-path /run/user/5000/speech-dispatcher/speechd.sock
SPEECHD_ADDRESS="unix_socket:/run/user/5000/speech-dispatcher/speechd.sock"
export SPEECHD_ADDRESS

echo "Start" >> ${LOGFILE}
date >> ${LOGFILE}

if test -n "${USER}"; then
  THEUSER=${USER}
else
  if test -n "${LOGNAME}"; then
    THEUSER="${LOGNAME}"
  fi
fi

# Make sure user is logged in
if test -n "${THEUSER}" ; then

#  LOGGEDN=( echo "true"  who | grep -i ^${THEUSER} | while read line; do PORT=`echo $line | cut -d\  -f2`; if test "${PORT}" = ":0" ; then export LOGGEDN=true ; echo "${THEUSER} logged in on XConsole"; echo "true"; fi; done )
  LOGGEDN=$( who | grep -i ^${THEUSER} | while read line; do PORT=`echo $line | cut -d\  -f2`; if test "${PORT}" = ":0" ; then echo "true"; fi; done )

else
  echo "User not known."
  env >> ${LOGFILE}
  set >> ${LOGFILE}
  exit 131
fi

if test "${LOGGEDN}" != "true"; then
  echo "${THEUSER} Not logged in." ${LOGFILE}
  exit 132
fi

echo "${THEUSER} logedn '${LOGGEDN}'" >> ${LOGFILE}


DISPLAY=:0.0
#/bin/date "+Time is %H:%M" | /usr/bin/festival --tts
TELLME=`/bin/date "+Time is %H:%M"`
/usr/bin/spd-say "${TELLME}"

echo "Done" >> ${LOGFILE}
date >> ${LOGFILE}

exit 0

