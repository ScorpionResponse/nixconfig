{ nixpkgs ? import <nixpkgs> {}, config, lib, pkgs, ... }:

let

  my_vim_configurable = pkgs.vim_configurable.override {
    python = pkgs.python38Full.withPackages (ps: with ps; [ pylama jedi pylint flake8 pynvim ]);
    wrapPythonDrv = true;
  };

  my_vimPlugins = [
    "ale"
    "delimitMate"
    "deoplete-nvim"
    "deoplete-jedi"
    "dracula"
    "hug-neovim-rpc"
    "indentLine"
    "nerdcommenter"
    "nvim-yarp"
    "python-mode"
    "reason-plus"
    "syntastic"
    "vim-abolish"
    "vim-airline"
    "vim-airline-themes"
    "vim-elixir"
    "vim-fugitive"
    "vim-nix"
    "vim-yaml"
    "vimproc"
  ];

  customPlugins = {
    # Dockerfile references $HOME and so doesn't work
    Dockerfile = pkgs.vimUtils.buildVimPlugin {
      name = "Dockerfile-git-2019-09-13";
      src = pkgs.fetchFromGitHub {
        owner = "ekalinin";
        repo = "Dockerfile.vim";
        rev = "bf29af1c79df21aefd3f68660cc8c57a78f14021";
        sha256 = "018cpf1202i740rmca37rm24nkqivizcjpiy19k0lnby689dda83";
      };
      meta = {
        homepage = https://github.com/ekalinin/Dockerfile.vim;
        maintainers = [ "ekalinin" ];
      };
    };

    hug-neovim-rpc = pkgs.vimUtils.buildVimPlugin {
      name = "hug-neovim-rpc-git-2020-04-21";
      src = pkgs.fetchFromGitHub {
        owner = "roxma";
        repo = "vim-hug-neovim-rpc";
        rev = "86e82de95e2a318589b718fef22eaeca1a3e3e04";
        sha256 = "1pbk3dfb9ag2jl0wvm9r1d513859q9qm32gr0zskqxvi2qgx6s1k";
      };
      meta = {
        homepage = https://github.com/roxma/vim-hug-neovim-rpc;
        maintainers = [ "roxma" ];
      };
    };

    reason-plus = pkgs.vimUtils.buildVimPlugin {
      name = "reason-plus-git-2020-02-19";
      src = pkgs.fetchFromGitHub {
        owner = "reasonml-editor";
        repo = "vim-reason-plus";
        rev = "c11a2940f8f3e3915e472c366fe460b0fe008bac";
        sha256 = "1vx7cwxzj6f12qcwcwa040adqk9cyzjd9f3ix26hnw2dw6r9cdr4";
      };
      meta = {
        homepage = https://github.com/reasonml-editor/vim-reason-plus;
        maintainers = [ "reasonml-editor" ];
      };
    };

    dracula = pkgs.vimUtils.buildVimPlugin {
      name = "dracula-git-2020-06-22";
      src = pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "vim";
        rev = "3916fb2daff546c6fe61d141b0e7519fde347b79";
        sha256 = "1f1l3ik15rqw9xqss22irpzxffcrpmihmga1q37gc1gvsnl6ibq5";
      };
      meta = {
        homepage = https://github.com/dracula/vim;
        maintainers = [ "dracula" ];
      };
    };
  };

in
{
  home.packages = with pkgs; [
    (my_vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile ./vimrc;
      vimrcConfig.vam.knownPlugins = vimPlugins // customPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        { names = my_vimPlugins; }
      ];
    })
  ];

  programs.bash.shellAliases.vi = "vim";
  nixpkgs.config.vim.ftNix = false;
}

