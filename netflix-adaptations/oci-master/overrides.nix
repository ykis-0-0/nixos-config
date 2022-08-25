{ config, lib, pkgs, ... }: {

  networking.hostName = "oci-master";

  users.users.root.password = "oci-rescue";
}
