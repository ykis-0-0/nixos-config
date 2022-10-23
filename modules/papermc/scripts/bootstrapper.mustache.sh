#!/usr/bin/env bash
# shellcheck shell=sh

: <<CAVEAT
  For maximal compatability, POSIX sh is assumed.
  Since we want 'pipefail', and Nix uses bash anyways,
  SC3040 is ignored next line.
CAVEAT

# shellcheck disable=SC3040
set -uo pipefail # Should we include -e as well...?

: <<USAGE
  ./bootstrap.sh launch <DTACH_SOCKFILE> <cmdline...>
  ./bootstrap.sh goto <cmdline...>
USAGE

DTACH_EXE="{{dtach}}/bin/dtach"

# RUNTIME_DIRECTORY set by systemd
subcommand=$1
shift

case "$subcommand" in
  "launch" )
    DTACH_SOCKFILE="$1"
    shift
    echo '[Bootstrapper] Starting dtach session'
    "$DTACH_EXE" -n "$DTACH_SOCKFILE" "$0" "goto" "$@"
  ;;

  "goto" )
    echo "$$" > "${RUNTIME_DIRECTORY}/jvm.pid"
    exec "$@"
  ;;

  * )
    exit 64
  ;;
esac
