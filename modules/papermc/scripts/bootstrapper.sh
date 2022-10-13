#!/usr/bin/env bash
# shellcheck shell=sh

: <<CAVEAT
  This piece of script is linted as POSIX Shell script is maximized compatibility.
  However, since Nix defaults to bash anyways, and 'set -o pipefail' is required,
  We'll need to deliberately ignore SC3040 in the next line.
CAVEAT

# shellcheck disable=SC3040
set -uo pipefail # Should we include -e as well...?

: <<USAGE
  ./bootstrap.sh <subcommand> <ABDUCO_SOCKFILE> <cmdline...>
USAGE

# RUNTIME_DIRECTORY set by systemd
subcommand=$1
shift

case "$subcommand" in
  "launch" )
    ABDUCO_SOCKFILE="$1"
    shift
    echo '[Bootstrapper] Starting abduco session'
    abduco -rn "$ABDUCO_SOCKFILE" "$0" "goto" "$@"
  ;;

  # BUG unable to pipe outputs to systemd journal
  # region Affected portions
  # "relay" )
  #   ABDUCO_SOCKFILE="$1"
  #   shift
  #   echo '[Bootstrapper] Starting abduco session and relaying stdout'
  #   abduco -rc "$ABDUCO_SOCKFILE" "$0" "goto" "$@"
  # ;;

  # "incept" )
  #   ABDUCO_SOCKFILE="$1"
  #   shift
  #   echo '[Bootstrapper] Execing into abduco client'
  #   exec abduco -rc "$ABDUCO_SOCKFILE" "$0" "goto" "$@"
  # ;;
  # endregion

  "goto" )
    logger --journald \
<<JOURNAL
IDENTIFIER=$(basename "$0")
PID=${PPID}
PRIORITY=6
MESSAGE=[Bootstrapper] Exec and handing over control to "$(basename "$1")"
JOURNAL
    systemd-notify --pid=$$
    exec "$@"
  ;;

  # BUG Invocation makes retrieval of PaperMC PID virtually impossible
  # "call" )
  #   echo '[Bootstrapper] Dropping into"'"$(basename "$2")"'"'
  #   "$@"
  # ;;

  * )
    exit 64
  ;;
esac
