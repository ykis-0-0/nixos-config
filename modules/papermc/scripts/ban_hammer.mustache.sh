#!/usr/bin/env bash
# shellcheck shell=sh

# shellcheck disable=SC3040
set -uo pipefail # Should we include -e as well...?

PWAIT_EXE="{{extrace}}/bin/pwait"
ABDUCO_EXE="{{abduco}}/bin/abduco"

do_pwait() {
  "$PWAIT_EXE" "$2"
  RETURN_CODE=$?
  echo "[Ban Hammer] ${1} has quitted with exit code ${RETURN_CODE}."
  return $RETURN_CODE
}

if [ "${MAINPID:-quitted}" = "quitted" ]; then
  echo "[Ban Hammer] Service spontaneously terminated, not issuing stop commands"
  exit 0
fi

echo "[Ban Hammer] Commanding PaperMC to /stop"
echo 'stop' | "$ABDUCO_EXE" -p "${RUNTIME_DIRECTORY}/abduco.sock"

echo "[Ban Hammer] Waiting for server processes to exit"
do_pwait "Abduco" "$MAINPID"&
do_pwait "PaperMC" "$(cat "${RUNTIME_DIRECTORY}/jvm.pid")"&

wait $! # Get PaperMC exit code
EXIT_WITH=$?

wait # for all `pwait`s above to stop
echo "[Ban Hammer] All unit processes has been stopped"

if [ $EXIT_WITH -ne 0 ] ; then
  echo >&2 "[Ban Hammer] PaperMC didn't exit cleanly, propagating exit code for Suppressor to handle."
  exit $EXIT_WITH
fi
