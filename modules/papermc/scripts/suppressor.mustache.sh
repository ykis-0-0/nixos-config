#!/usr/bin/env bash
# shellcheck shell=sh

# shellcheck disable=SC3040
set -uo pipefail # Should we include -e as well...?

subcommand=$1
shift

# SC2155 fix
LOCATION="$(pwd)"
readonly LOCATION
readonly FILENAME="obelisk-of-doom"
readonly CHECK_PATH="${LOCATION}/${FILENAME}"

case "$subcommand" in
  "act" )
    if [ "${SERVICE_RESULT:-unknown}" = "success" ] ; then
      echo "[Suppressor] Service exited cleanly, cleaning up own artifacts"
      rm "$CHECK_PATH"
      exit 0
    fi

    echo >&2 "[Suppressor] Service had abnormal exit, I will remember that."
    echo "downed" > "$CHECK_PATH"
    date --iso-8601=seconds > "$CHECK_PATH"
  ;;
  "check" )
    if [ -f "$CHECK_PATH" ] ; then
      echo >&2 "[Suppressor] Service did not exit cleanly on the last run, inducing failure to prevent further data corruption"
      exit 1
    fi

    echo "No mark of service failure detected, proceeding"
    echo "up" > "$CHECK_PATH"
    date --iso-8601=seconds >> "$CHECK_PATH"
  ;;
  "*" )
    echo >&2 "[Suppressor] Unknown action $subcommand!"
  ;;
esac
