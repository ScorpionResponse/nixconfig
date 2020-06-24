# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.interfaces.enp0s8.ipv4.addresses = [ {
    address = "192.168.75.101";
    prefixLength = 24;
  } ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    git
    wget 
    neovim
    python38Full
    python38Packages.pynvim
    ((vim_configurable.override { python = python3; }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    })
  ];

  environment.variables.EDITOR = "vim";

  # Docker
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Security
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Nix
  nix.allowedUsers = [ "@wheel" ];

  # Define a user account
  users.users.phile = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtjudDR2MY7i3wnJQ4C3K2qCVjtfRi9UOeBZCLN+uYfbP2Vr2e5itiiTFqsj/Q2/BG41slwT/E/txW1fkz2UQYGIzGbOW2wUI3iE6MdcXwc4MdN/iiVNIBr2H28EDhKK6vA2ZPIJfv7+BELDuupxw7ep8Eul5KUrsSktOowWooT2whWMxEUIeErGrB+wgaqW379xt4CsiMLtV87le2PcjMgHmEOVLjT3c2z2phi8s04uGQe4LYbc/q3WmZAqHC26JJ0AHpMabLRWS/5/6DMc6AogwLH+6VRrTwy5xjf3tuDNbDSiO/g1qWHY/NMiOVX0iSSgywEEideaKCh15IiGYf phile@DESKTOP-N3LEB91" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
