{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
  ];
 
  programs.bash = {
    enable = true;
    shellAliases = {
      vi = "vim";
    };
    bashrcExtra = builtins.readFile ~/.config/dotfiles/dotfiles/bashrc;
  };
}

