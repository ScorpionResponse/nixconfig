{ config, lib, pkgs, ... }:

let

  my_vim_configurable = pkgs.vim_configurable.override {
    python = pkgs.python38Full.withPackages (ps: with ps; [ pylama jedi pylint flake8 pynvim ]);
    wrapPythonDrv = true;
  };

  my_vimPlugins = with pkgs.vimPlugins; [
    vim-nix
  ];

in
{
  home.packages = with pkgs; [
    (my_vim_configurable.customize {
      name = "vim";
      vimrcConfig.packages.myVimPackages = {
        start = my_vimPlugins;
      };
      vimrcConfig.customRC = builtins.readFile ~/.config/dotfiles/dotfiles/vimrc;
    })
  ];

  # home.file = {
  #   ".vimrc".source = ~/.config/dotfiles/dotfiles/vimrc;
  # };
}

