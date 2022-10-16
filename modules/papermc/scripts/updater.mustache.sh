#!/usr/bin/env bash
# shellcheck shell=sh

: <<EOC
  This piece of script is linted as POSIX Shell script is maximized compatibility.
  However, since Nix defaults to bash anyways, and 'set -o pipefail' is required,
  We'll need to deliberately ignore SC3040 in the next line.
EOC

# shellcheck disable=SC3040
set -uo pipefail # Should we include -e as well...?

WGET_EXE="{{wget}}/bin/wget"
JQ_EXE="{{jq}}/bin/jq"

# region Version Info fetchers
check_version () (
  "$WGET_EXE" -qO- "https://papermc.io/api/v2/projects/paper" | "$JQ_EXE" -r '.versions[-1]'

  hresult=$?
  if [ "$hresult" -ne 0 ]; then
    echo >&2 "[Updater] Unable to retrieve available PaperMC versions, aborting."
    exit $hresult
  fi
)

check_build () (
  "$WGET_EXE" -qO- "$base_url" | "$JQ_EXE" -r '.builds | max'

  hresult=$?
  if [ "$hresult" -ne 0 ]; then
    echo >&2 "[Updater] Unable to retrieve PaperMC builds of version [${MINECRAFT_VERSION}], aborting."
    exit $hresult
  fi
)

check_jar () (
  jar_url="${base_url}/builds/${using_build}"
  "$WGET_EXE" -qO- "$jar_url" | "$JQ_EXE" -r '.downloads.application.name'

  hresult=$?
  if [ "$hresult" -ne 0 ]; then
    echo >&2 "[Updater] Unable to retrieve JAR filename for PaperMC v${MINECRAFT_VERSION} build [${using_build}], aborting."
    exit $hresult
  fi
)
# endregion

# region Figure out the newest build of the current version
echo "[Updater] Checking server JAR updates for version ${MINECRAFT_VERSION=$(check_version)}"

base_url="https://papermc.io/api/v2/projects/paper/versions/${MINECRAFT_VERSION}"
newest_build=$(check_build)

echo "[Updater] Newest PaperMC build for ${MINECRAFT_VERSION} is ${newest_build}"
using_build=${PAPER_BUILD:-$newest_build} # fallback to newest if (null || unset)
(
  unset build_type # to prevent outside contamination
  build_type="${PAPER_BUILD:+pinned}" # null iff (set && !null)
  build_type="${build_type:-newest}"
  echo "[Updater] Using PaperMC for Minecraft ${MINECRAFT_VERSION}, on the ${build_type} build ${newest_build}"
)

echo "[Updater] Checking local existence for ${JAR_NAME=$(check_jar)}"
# endregion

# region Check local copy of server JAR
if [ "${BIN_DIR+defined}" != "defined" ] || [ ! -d "$BIN_DIR" ] || [ ! -w "$BIN_DIR" ]; then
  echo >&2 "[Updater] BIN_DIR not pointing to a valid, existing, and writable directory, aborting."
  exit 1
fi

if [ -e "${BIN_DIR}/${JAR_NAME}" ]; then
  echo "[Updater] Server JAR up-to-date."
else
  download_url="${base_url}/builds/${using_build}/downloads/${JAR_NAME}"
  echo "[Updater] Downloading from ${download_url}"
  echo "[Updater] ... and Saving to ${BIN_DIR}"
  echo

  "$WGET_EXE" --progress=dot:mega -P "$BIN_DIR" "$download_url"
fi
# endregion

# region Make symbolic links
(
  echo "[Updater] Updating symbolic links if required"
  version_jar="${BIN_DIR}/paper-${MINECRAFT_VERSION}.jar"
  if [ ! -L "$version_jar" ] || [ ! "$(readlink "${version_jar}")" = "$JAR_NAME" ]; then
    ln -vfs "$JAR_NAME" "${BIN_DIR}/paper-${MINECRAFT_VERSION}.jar"
  fi

  using_jar="${BIN_DIR}/paper.jar"
  if [ ! -L "$using_jar" ] || [ ! "$(readlink "${using_jar}")" = "$JAR_NAME" ] ; then
    ln -vfs "$JAR_NAME" "${BIN_DIR}/paper.jar"
  fi
)

echo "[Updater] Completed, handing back to systemd"
# endregion
