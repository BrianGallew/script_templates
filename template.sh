#!/bin/bash
#
# Author: Duncan Hutty <>
# Last Modified: 2014-10-01
# Usage: ./$0 [options] <args>
#
# Description:
#
#
# Input:
#
# Output:
#
# Examples:
#
# Dependencies:
#
# Assumptions:
#
# Notes:
#
# Bashisms:
#   local (works on most non-commercial shells)


#set -o nounset  # error on referencing an undefined variable, breaks optarg
#set -o errexit  # exit on command or pipeline returns non-true
#set -o pipefail # exit if *any* command in a pipeline fails, not just the last

PROGNAME=$( basename $0 )
SUMMARY="one line summary"

#defaults
force=0
verbosity=0

# Import library functions, if any
PROGPATH=$( dirname $0 )
test -f $PROGPATH/utils.sh && . $PROGPATH/utils.sh

usage() {
    echo
    if [ -n "${1}" ]
    then
	echo "$*";echo
    fi
    cat <<EOF
${SUMMARY}
Usage: $PROGNAME [options] [<args>]


	-f force"
	-h Print this usage"
	-v Increase verbosity"

EOF
}

log() {  # standard logger: log "INFO" "something happened"
    if [ ${verbosity} -gt 0 ]
    then
	local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
	echo "${prefix} $@" >&2
    fi
}

while getopts "fhvV" OPTION;
do
  case "$OPTION" in
    f) force=1 ;;
    h) usage
       exit 0 ;;
    v) verbosity=$(($verbosity+1)) ;;
    *) echo "Unrecognised Option: ${OPTARG}"
       exit 1 ;;
  esac
done

[ ${verbosity:-0} -gt 2 ] && set -x

# This pulls all the processed arguments out of $*, so now $1 is the first
# positional argument.
shift $((OPTIND - 1))

