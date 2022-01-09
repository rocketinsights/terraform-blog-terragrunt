#!/usr/bin/env bash

# This this the Rocker Insights bash template
# Contains functionality all 
# See function print_usage for details about this script
# https://mywiki.wooledge.org/BashFAQ
# https://matt.might.net/articles/bash-by-example/

###############################
# HEADERS
###############################
# When a command executed by the bash script fails, the script will exit with the error code
set -o errexit
# No unset. Script will exit when an undeclared variable is used. Good for catching variable name typos
set -o nounset
# When multiple commands are chained via pipe, the bash script will exit with the error code
# of the last command that failed
set -o pipefail

# Uncomment to turn on debugging or run as "bash -x SCRIPT_NAME"
# Outputs the executed commands. Useful for debugging
# set -o xtrace

# Get the absolute path and name of this bash script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SCRIPT_DIR
SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_NAME

###############################
# FUNCTIONS
###############################
print_usage() {
  cat << EOF
USAGE of ${SCRIPT_NAME}
NAME
  ${SCRIPT_NAME} -- Describe purpose of script

SYNOPSIS
  ${SCRIPT_NAME} [-optional_opts] -r required_opts

DESCRIPTION
  The detailed description of the script.

  The options are as follows:

ENVIRONMENT
  The following environment variables affect the execution of ${SCRIPT_NAME}:

FILES
  Describe any files read or written to by ${SCRIPT_NAME}, e.g. log files

EXIT STATUS
  The ${SCRIPT_NAME} script exits:
  0  On success
  1  On generic failure
  2  On specific error

EXAMPLES
  ${SCRIPT_NAME} -h
    Prints out the help page

BUGS
  No known bugs

AUTHOR
  Jirawat Uttayaya
    Email: jirawat.uttayaya@rocketinsights.com

EOF

  return 0
}

log() {
  # SC2155 : Declare and assign separately to avoid masking return values
  local log_datetime
  log_datetime=$(date +"%Y-%m-%d %H:%M:%S %Z")
  local -r log_datetime

  # The ${1:-} sets the bash variable to empty if $1 is not set
  # The syntax is needed to not trigger unbound variable errors from 'set -o nounset'
  local -r log_level="${1:-}"
  local -r log_msg="${2:-}"

  if [[ -z $log_level || -z $log_msg ]]; then
    echo "${log_datetime} [WARN] called log bash function with missing parameters" 1>&2
    echo "${log_datetime} [WARN] Usage: log 'LOG_LEVEL' 'LOG_MESSAGE'" 1>&2
  fi
  local -r full_msg="${log_datetime} [${log_level}] ${log_msg}"
  if [[ "${log_level}" == "ERROR" ]]; then
    echo "${full_msg}" 1>&2
  else
    echo "${full_msg}"
  fi
  return 0
}

###############################
# TRAPS
###############################
trap_always_run_on_exit_or_err() {
  # The script will execute this function before exiting
  # Useful for cleanup commands
  # Mimics the finally block from Java
  local -r err_code="${?}"

  # Put the cleanup commands below

  log "INFO" "End execution ${SCRIPT_DIR}/${SCRIPT_NAME}"
  exit "${err_code}"
}
trap trap_always_run_on_exit_or_err EXIT ERR

###############################
# Get command line options
###############################
OPT_VERBOSE=0
OPT_CONFIGFILE=""
parse_cmd_options() {
  # It is just my personal preference to parse command line options via a simple while loop.
  # The while loop is flexible and supports long style commands, e.g. --help
  # Feel free to use getopts if that is your jam
  while :; do
    case "${1:-}" in
      -h|--help)
        print_usage  # Show the help page, i.e. print_usage
        exit 0
        ;;
      -v|--verbose)
        OPT_VERBOSE=1
        ;;
      -c|--config)
        if [[ "${2:-}" && -f "${2:-}" ]]; then
          OPT_CONFIGFILE="${2}"
          shift
        else
          log "ERROR" "${2:-'MISSING FILE'} in an invalid config file for the -c option"
          exit 4
        fi
        ;;
      -?*)
        # handles unknown options
        log "ERROR" "Unknown option ${1}"
        print_usage
        exit 3
        ;;
      *)   # Default case
        if [[ -z "${1:-}" ]]; then
          # No more options, so break out of the parse_cms_options loop.
          break
        fi

        # handles unknown command line argument
        log "ERROR" "Unknown command line argument ${1}"
        print_usage
        exit
        ;;
    esac
    shift
  done

  return 0
}
###############################
# MAIN
###############################
main() {
  log "INFO" "Start execution ${SCRIPT_DIR}/${SCRIPT_NAME}"
  parse_cmd_options "${@:-}"
  if [[ ${OPT_VERBOSE} -eq 1 ]]; then
    log "INFO" "In VERBOSE mode"
  fi
  if [[ -n "${OPT_CONFIGFILE}" && ${OPT_VERBOSE} -eq 1 ]]; then
    log "INFO" "Reading config file ${OPT_CONFIGFILE}"
  fi
  exit 0
}

main "${@:-}"