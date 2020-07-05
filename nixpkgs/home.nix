{ config, pkgs, ... }:

with builtins;
with import <nixpkgs> {};
with lib;

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./home/git.nix
    ./home/vim.nix
    ./home/bash.nix
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";

  home.packages = with pkgs; [
    nixfmt
    unzip
  ];

  home.file = {
    ".config/dotfiles".source = fetchFromGitHub {
      owner = "scorpionresponse";
      repo = "dotfiles";
      rev = "1b57b49";
      sha256 = "032nwmp2sfjjykbqg4yfj35r5sxhg1ysm237bhzp5z9fngs73qj1";
    };
  };
}
