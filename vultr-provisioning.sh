#!/bin/sh
#
# Install NixOS on a Vultr VPS

umount /dev/vda*

# create partitions (with 2GB swap)
parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MB -2GB
parted /dev/vda -- set 1 boot on
parted /dev/vda -- mkpart primary linux-swap -2GB 100%

# Formatting
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2

# create filesystem and mount
mount /dev/disk/by-label/nixos /mnt

# enable swap
swapon /dev/vda2
free -h

# pause (just so I can see the output above)
sleep 5

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

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

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

echo "Done. Now reboot via Settings > Custom ISO > Remove ISO on the Vultr web UI."
