#!/bin/sh
#
# Install NixOS on a Vultr VPS

umount /dev/vda*

# create partitions (with 2GB swap)
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart root ext4 512MB -2GB
parted /dev/vda -- mkpart swap linux-swap -2GB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 3 esp on

# Formatting
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3

# create filesystem and mount
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

# enable swap
swapon /dev/vda2
free -h

# generate NixOS config
nixos-generate-config --root /mnt
echo "System configuration.nix:"
tee /mnt/etc/nixos/configuration.nix <<EOF
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  boot.loader.systemd-boot.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  users.users.root = {
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGBb8IEgCtdh/2D4+OWQMsahqd3dTGJQogDMfL4eLFw phile@nixdevbox"];
  };

  system.stateVersion = "25.05";
}
EOF

# install NixOS
nixos-install --no-root-passwd

# unmount
sync
umount /dev/disk/by-label/boot
umount /dev/disk/by-label/nixos

echo "Done. Now reboot via \"Remove ISO\" on the Vultr web UI."