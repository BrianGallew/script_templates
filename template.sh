#!/bin/bash
#
# Author: Duncan Hutty <>
# Last Modified: 2014-10-01
# Usage: ./$0 [options] <args>
#
SUMMARY="one line summary"
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
#   $((expr)) instead of "let"
#   [[ ]] instead of POSIX [ ]


set -o nounset  # error on referencing an undefined variable
#set -o errexit  # exit on command or pipeline returns non-true
#set -o pipefail # exit if *any* command in a pipeline fails, not just the last

VERSION="0.1.0"
PROGNAME=$( basename $0 )
PROGPATH=$( dirname $0 )

# Import library functions
#. $PROGPATH/utils.sh

print_usage() {
  echo "${SUMMARY}"; echo ""
  echo "Usage: $PROGNAME [options] [<args>]"
  echo ""

  echo "-f force"
  echo "-h Print this usage"
  echo "-v Increase verbosity"
  echo "-V Print version number and exit"
}

print_help() {
    echo "$PROGNAME $VERSION"
    echo ""
    print_usage
}

#defaults
force=0
verbosity=0

while getopts "fhvV" OPTION;
do
  case "$OPTION" in
    f) force=1 ;;
    h) print_help
       exit 0 ;;
    v) verbosity=$(($verbosity+1)) ;;
    V) echo "${VERSION}"
       exit 0 ;;
    *) echo "Unrecognised Option: ${OPTARG}"
       exit 1 ;;
  esac
done

log() {  # standard logger: log "INFO" "something happened"
   local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
   echo "${prefix} $@" >&2
}

[[ ${verbosity:-0} -gt 2 ]] && set -x
shift $((OPTIND - 1))

