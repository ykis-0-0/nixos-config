#! /usr/bin/env bash

# Usage: curl -L https://github.com/ykis-0-0/nixos-config/raw/master/infect-oci.sh | sudo FLAKE_URL="<Your flake_ref here>" NIXOS_CONFIG_NAME="<flake output to use>" bash -x
# More info at: https://github.com/elitak/nixos-infect

set -e -o pipefail

# region Swap related
# From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L145-L170
checkExistingSwap() {
  SWAPSHOW=$(swapon --show --noheadings --raw)
  zramswap=true
  swapcfg=""
  if [[ -n "$SWAPSHOW" ]]; then
    SWAP_DEVICE="${SWAPSHOW%% *}"
    if [[ "$SWAP_DEVICE" == "/dev/"* ]]; then
      zramswap=false
      swapcfg="swapDevices = [ { device = \"${SWAP_DEVICE}\"; } ];"
      NO_SWAP=true
    fi
  fi
}

makeSwap() {
  swapFile=$(mktemp /tmp/nixos-infect.XXXXX.swp)
  dd if=/dev/zero "of=$swapFile" bs=1M count=$((1*1024))
  chmod 0600 "$swapFile"
  mkswap "$swapFile"
  swapon -v "$swapFile"
}

removeSwap() {
  swapoff -a
  rm -vf /tmp/nixos-infect.*.swp
}
#endregion

isX86_64() {
  [[ "$(uname -m)" == "x86_64" ]]
}

# region EFI detection
# From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L172-L188
isEFI() {
  [ -d /sys/firmware/efi ]
}

findESP() {
  esp=""
  for d in /boot/EFI /boot/efi /boot; do
    [[ ! -d "$d" ]] && continue
    [[ "$d" == "$(df "$d" --output=target | sed 1d)" ]] \
      && esp="$(df "$d" --output=source | sed 1d)" \
      && break
  done
  [[ -z "$esp" ]] && { echo "ERROR: No ESP mount point found"; return 1; }
  for uuid in /dev/disk/by-uuid/*; do
    [[ $(readlink -f "$uuid") == "$esp" ]] && echo $uuid && return 0
  done
}
# endregion

# region Prerequisite checks <MODIFIED>
# From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L241-L269

prepareEnv() {
  # $esp and $grubdev are used in makeConf()
  if isEFI; then
    esp="$(findESP)"
  else
    for grubdev in /dev/vda /dev/sda /dev/xvda /dev/nvme0n1 ; do [[ -e $grubdev ]] && break; done
  fi

  : << 'SKIPCONF'
  # Retrieve root fs block device
  #                   (get root mount)  (get partition or logical volume)
  rootfsdev=$(mount | grep "on / type" | awk '{print $1;}')
  rootfstype=$(df $rootfsdev --output=fstype | sed 1d)
SKIPCONF

  # DigitalOcean doesn't seem to set USER while running user data
  # Also the case for Oracle
  export USER="root"
  export HOME="/root"

  # Nix installer tries to use sudo regardless of whether we're already uid 0
  #which sudo || { sudo() { eval "$@"; }; export -f sudo; }
  # shellcheck disable=SC2174
  : 'mkdir -p -m 0755 /nix' # SKIPPED
}

fakeCurlUsingWget() {
  # Too lazy to even copy this shit
  return 1
}

req() {
  type "$1" > /dev/null 2>&1 || which "$1" > /dev/null 2>&1
}

checkEnv() {
  [[ "$(whoami)" == "root" ]] || { echo "ERROR: Must run as root"; return 1; }

  # Perform some easy fixups before checking
  # TODO prevent multiple calls to apt-get update
  (which dnf && dnf install -y perl-Digest-SHA) || true # Fedora 24
  which bzcat || (which yum && yum install -y bzip2) \
              || (which apt-get && apt-get update && apt-get install -y bzip2) \
              || true
  which xzcat || (which yum && yum install -y xz-utils) \
              || (which apt-get && apt-get update && apt-get install -y xz-utils) \
              || true
  which curl  || fakeCurlUsingWget \
              || (which apt-get && apt-get update && apt-get install -y curl) \
              || true

  req curl || req wget || { echo "ERROR: Missing both curl and wget";  return 1; }
  req bzcat            || { echo "ERROR: Missing bzcat";               return 1; }
  req xzcat            || { echo "ERROR: Missing xzcat";               return 1; }
  req groupadd         || { echo "ERROR: Missing groupadd";            return 1; }
  req useradd          || { echo "ERROR: Missing useradd";             return 1; }
  req ip               || { echo "ERROR: Missing ip";                  return 1; }
  req awk              || { echo "ERROR: Missing awk";                 return 1; }
  req cut || req df    || { echo "ERROR: Missing coreutils (cut, df)"; return 1; }

  # On some versions of Oracle Linux these have the wrong permissions,
  # which stops sshd from starting when NixOS boots
  chmod 600 /etc/ssh/ssh_host_*_key
}
#endregion

infect() { # HEAVILY MODIFIED
  # region Get Nix into the system
  # From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L274-L285
  # Add nix build users
  # FIXME run only if necessary, rather than defaulting true
  groupadd nixbld -g 30000 || true
  for i in {1..10}; do
    useradd -c "Nix build user $i" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" "nixbld$i" || true
  done
  # TODO use addgroup and adduser as fallbacks
  #addgroup nixbld -g 30000 || true
  #for i in {1..10}; do adduser -DH -G nixbld nixbld$i || true; done

  curl -L https://nixos.org/nix/install | sh -s -- --no-channel-add

  # shellcheck disable=SC1090
  source ~/.nix-profile/etc/profile.d/nix.sh

  : << 'NONFLAKE'
  [[ -z "$NIX_CHANNEL" ]] && NIX_CHANNEL="nixos-22.11"
  nix-channel --remove nixpkgs
  nix-channel --add "https://nixos.org/channels/$NIX_CHANNEL" nixos
  nix-channel --update

  if [[ $NIXOS_CONFIG = http* ]]
  then
    curl $NIXOS_CONFIG -o /etc/nixos/configuration.nix
    unset NIXOS_CONFIG
  fi

  export NIXOS_CONFIG="${NIXOS_CONFIG:-/etc/nixos/configuration.nix}"
NONFLAKE

  # endregion

  # Flake adaptations
  nix \
    --extra-experimental-features "nix-command flakes" \
  build \
    --profile /nix/var/nix/profiles/system \
    "${FLAKE_URL}#nixosConfigurations.${NIXOS_CONFIG_NAME}.config.system.build.toplevel"
  : # Code folding really sucks

  : << 'NONFLAKE'
  nix-env --set \
    -I nixpkgs=$HOME/.nix-defexpr/channels/nixos \
    -f '<nixpkgs/nixos>' \
    -p /nix/var/nix/profiles/system \
    -A system
NONFLAKE

  # region Activate everything
  # From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L300-L323

  # Remove nix installed with curl | bash
  rm -fv /nix/var/nix/profiles/default*
  /nix/var/nix/profiles/system/sw/bin/nix-collect-garbage

  # Reify resolv.conf
  [[ -L /etc/resolv.conf ]] && mv -v /etc/resolv.conf /etc/resolv.conf.lnk && cat /etc/resolv.conf.lnk > /etc/resolv.conf

  : << 'SKIPPED'
  # Set label of root partition
  if [ -n "$newrootfslabel" ]; then
    echo "Setting label of $rootfsdev to $newrootfslabel"
    e2label "$rootfsdev" "$newrootfslabel"
  fi
SKIPPED

  # Stage the Nix coup d'état
  touch /etc/NIXOS
  echo etc/nixos                  >> /etc/NIXOS_LUSTRATE
  echo etc/resolv.conf            >> /etc/NIXOS_LUSTRATE
  echo root/.nix-defexpr/channels >> /etc/NIXOS_LUSTRATE
  (cd / && ls etc/ssh/ssh_host_*_key* || true) >> /etc/NIXOS_LUSTRATE

  rm -rf /boot.bak
  isEFI && umount "$esp"

  mv -v /boot /boot.bak || { cp -a /boot /boot.bak ; rm -rf /boot/* ; umount /boot ; }
  if isEFI; then
    INFECT_EFI_PATH=${INFECT_EFI_PATH:-/boot}
    mkdir -p $INFECT_EFI_PATH
    mount "$esp" $INFECT_EFI_PATH
    find $INFECT_EFI_PATH -depth ! -path $INFECT_EFI_PATH -exec rm -rf {} +
  fi
  /nix/var/nix/profiles/system/bin/switch-to-configuration boot
  # endregion
}

: << 'SKIPCONF'
[ "$PROVIDER" = "digitalocean" ] && doNetConf=y # digitalocean requires detailed network config to be generated
[ "$PROVIDER" = "lightsail" ] && newrootfslabel="nixos"
if [[ "$PROVIDER" = "digitalocean" ]] || [[ "$PROVIDER" = "servarica" ]] || [[ "$PROVIDER" = "hetznercloud" ]]; then
	doNetConf=y # some providers require detailed network config to be generated
fi
SKIPCONF

# region Main Infect Flow <MODIFIED>
# From https://github.com/elitak/nixos-infect/blob/master/nixos-infect#L330-L333
if [[ -z "${FLAKE_URL:=$1}" ]]; then
  echo "Flake URL required!"
  exit 1
fi
if [[ -z "${NIXOS_CONFIG_NAME:=$2}" ]]; then
  echo "Desired NixOS Configuration Name required"
  exit 1
fi

checkEnv
prepareEnv
checkExistingSwap
if [[ -z "$NO_SWAP" ]]; then
    makeSwap # smallest (512MB) droplet needs extra memory!
fi
# makeConf
infect
if [[ -z "$NO_SWAP" ]]; then
    removeSwap
fi

if [[ -z "$NO_REBOOT" ]]; then
  reboot
fi
#endregion
