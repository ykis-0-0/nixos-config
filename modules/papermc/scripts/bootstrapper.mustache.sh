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
  ./bootstrap.sh launch <ABDUCO_SOCKFILE> <cmdline...>
  ./bootstrap.sh goto <cmdline...>
USAGE

ABDUCO_EXE="{{abduco}}/bin/abduco"

# RUNTIME_DIRECTORY set by systemd
subcommand=$1
shift

case "$subcommand" in
  "launch" )
    ABDUCO_SOCKFILE="$1"
    shift
    echo '[Bootstrapper] Starting abduco session'
    "$ABDUCO_EXE" -rn "$ABDUCO_SOCKFILE" "$0" "goto" "$@"
  ;;

  "goto" )
    echo "$$" > "${RUNTIME_DIRECTORY}/jvm.pid"
    exec "$@"
  ;;

  * )
    exit 64
  ;;
esac
