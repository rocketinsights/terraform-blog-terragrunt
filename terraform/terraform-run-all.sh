#!/usr/bin/env bash

# This this the Rocker Insights bash template
# Contains the minimal functionalities most bash scripts need
# * Right bash settings (sets and traps)
# * Man page style documentation
# * Rudimentary logging
# * Command line options parsing and sensible default options
# * Best practice for bash, e.g. readonly local variables
#
# Please feel free to modify for personal taste

# See function print_usage for documentation about usage of script
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

# Uncomment to turn on debugging or run as "bash -x SCRIPT_NAME" or use this script --debug option
# Outputs the executed commands. Useful for debugging
# set -o xtrace

# Get the absolute path and name of this bash script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SCRIPT_DIR
SCRIPT_NAME=$(basename "${0}")
readonly SCRIPT_NAME

###############################
# FUNCTIONS
###############################
print_usage() {
  cat << EOF
USAGE of ${SCRIPT_NAME}
NAME
  ${SCRIPT_NAME} -- Runs the Terraform subcommand in the correct state section order

SYNOPSIS
  ${SCRIPT_NAME} [-h|--help] [-d|--debug] [-v|--verbose] [-c config_file]

DESCRIPTION
  Reads the required config file that list the correct order of the Terraform state section.
  Then runs the subcommand sequentially in the correct order.
  Mimics Terragrunt run-all command.

  The options are as follows:

  -h|--help       Displays the usage page

  -d|--debug      Executes script in DEBUG mode and shows all commands executed.
                  Equivalent to "set -o xtrace"

  -v|--verbose    Execute script with TRACE logging on

  -c|--config     REQUIRED. A text file with the Terraform state section listed in the correct execution order

  -s|--subcommand REQUIRED. Terraform subcommand to execute such as 'validate', 'plan', 'apply', 'destroy'

ENVIRONMENT
  The following environment variables affect the execution of ${SCRIPT_NAME}:

  TF_LOG : Changes level of Terraform logging

  TF_LOG_PATH: File output for TF_LOG messages

FILES
  Describe any files read or written to by ${SCRIPT_NAME}, e.g. log files

EXIT STATUS
  The ${SCRIPT_NAME} script exits:
  0  On success
  1  On generic failure
  2  Invalid command line options
  3  Invalid config file
  4  Invalid subcommand

EXAMPLES
  ${SCRIPT_NAME} -h
    Prints out the help page

  ${SCRIPT_NAME} -c run-all.order -s apply
    Reads the run-all.order config file and runs 'terraform apply' in the order listed in run-all.order

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
  elif [[ "${log_level}" == "TRACE" ]]; then
    if [[ ${OPT_VERBOSE} -eq 1 ]]; then
      echo "${full_msg}"
    fi
  else
    echo "${full_msg}"
  fi
  return 0
}

array_contains_element() {
  local -r match_str="${1:-}"
  shift
  # shellcheck disable=SC2124
  local -r p_array_check="${@:-}"
  local -r p_array=( "${@:-}" )
  local array_element

  if [[ -z "${match_str}" || -z "${p_array_check}" ]]; then
    log "ERROR" "array_contains_element requires two parameters: the matching string and the array elements"
    # shellcheck disable=SC2016
    log "ERROR" 'Example: array_contains_element "matchString" "${array[@]}"'
    exit 1
  fi

  for array_element in "${p_array[@]}"; do
    [[ "${match_str}" == "${array_element}" ]] && return 0
  done

  return 1
}
parse_config_run_all_order() {
  log "TRACE" "Reading config file ${OPT_CONFIGFILE}"
  if [[ -z "${OPT_CONFIGFILE}" ]]; then
    log "ERROR" "OPT_CONFIGFILE variable is not set"
    exit 3
  fi

  local line
  # shellcheck disable=SC1097
  while read -r line; do
    # Ignore comments in properties file
    [[ "${line}" = \#* ]] && continue
    # Ignore blank spaces
    [[ -z "${line}" ]] && continue

    # trim leading and trailing spaces from key and value
    local trimline
    trimline=$(echo "${line}" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')
    log "TRACE" "Line:${trimline}|"
    run_all_order+=("${line}")
  done < "${OPT_CONFIGFILE}"
}

execute_run_all_order() {
  local tf_idx
  local -r tf_count=${#run_all_order[@]}
  for tf_idx in "${!run_all_order[@]}";do
    printf "Executing ${OPT_SUBCOMMAND} %d of %d: %s\n" "$((tf_idx+1))" "${tf_count}" "${run_all_order[${tf_idx}]}"
    cd "${SCRIPT_DIR}/${run_all_order[${tf_idx}]}"
    terraform init -upgrade
    terraform "${OPT_SUBCOMMAND}"
  done
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

  log "INFO" "End execution ${SCRIPT_DIR}/${SCRIPT_NAME} with exit code ${err_code}"
  exit "${err_code}"
}
trap trap_always_run_on_exit_or_err EXIT ERR

###############################
# Get command line options
###############################
OPT_VERBOSE=0
OPT_CONFIGFILE=""
OPT_SUBCOMMAND=""

# An array of the correct order to run the Terraform sections
unset run_all_order

validate_cmd_options() {
  if [[ -z "${OPT_CONFIGFILE}" ]]; then
    log "ERROR" "-c config_file is required"
    exit 3
  fi
  if [[ -z "${OPT_SUBCOMMAND}" ]]; then
    log "ERROR" "-s subcommand is required"
    exit 3
  fi

  return 0
}

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
      -d|--debug)
        set -o xtrace
        ;;
      -c|--config)
        if [[ "${2:-}" && -f "${2:-}" ]]; then
          OPT_CONFIGFILE="${2}"
          shift
        else
          log "ERROR" "${2:-'MISSING FILE'} in an invalid config file for the -c option"
          exit 3
        fi
        ;;
      -s|--subcommand)
        if [[ -z "${2:-}" ]]; then
          log "ERROR" "A Terraform subcommand is required for -s option"
          exit 4
        fi

        local valid_subcommands=(validate plan apply destroy)
        if array_contains_element "${2}" "${valid_subcommands[@]}"; then
          OPT_SUBCOMMAND="${2}"
          shift
        else
          log "ERROR" "The subcommand ${2} is not valid"
          log "ERROR" "Subcommand must be one of these values: ${valid_subcommands[*]}"
          exit 4
        fi
        ;;
      -?*)
        # handles unknown options
        print_usage
        log "ERROR" "Unknown option ${1}"
        exit 2
        ;;
      *)   # Default case
        if [[ -z "${1:-}" ]]; then
          # No more options, so break out of the parse_cms_options loop.
          break
        fi

        # handles unknown command line argument
        print_usage
        log "ERROR" "Unknown command line argument ${1}"
        exit 2
        ;;
    esac
    shift
  done

  validate_cmd_options
  return 0
}

###############################
# MAIN
###############################
main() {
  log "INFO" "Start execution ${SCRIPT_DIR}/${SCRIPT_NAME}"
  parse_cmd_options "${@:-}"
  log "TRACE" "In VERBOSE mode"
  parse_config_run_all_order
  execute_run_all_order
  exit 0
}

main "${@:-}"