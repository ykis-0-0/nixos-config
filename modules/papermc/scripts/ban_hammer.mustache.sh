#!/usr/bin/env bash
# shellcheck shell=sh

PWAIT_EXE="{{extrace}}/bin/pwait"
ABDUCO_EXE="{{abduco}}/bin/abduco"

do_pwait() {
  "$PWAIT_EXE" "$2"
  echo "[Ban Hammer] ${1} has quitted"
}

echo "[Ban Hammer] Commanding PaperMC to /stop"
echo 'stop' | "$ABDUCO_EXE" -p "${RUNTIME_DIRECTORY}/abduco.sock"

echo "[Ban Hammer] Waiting for server processes to exit"
do_pwait "PaperMC" "$(cat "${RUNTIME_DIRECTORY}/jvm.pid")"&
do_pwait "Abduco" "$MAINPID"&

wait # for all `pwait`s above to stop
echo "[Ban Hammer] All unit processes has been stopped"
