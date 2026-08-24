{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    autoconf
    phpPackages.composer
    fd
    ffmpeg
    fzf
    glow
    gnupg
    grafana
    imagemagick
    jq
    lazygit
    # mas (Darwin only)
    mise
    neovim
    openexr
    poppler-utils
    resvg
    ripgrep
    _7zz
    sheldon
    tmux
    tree
    tree-sitter
    usage
    yazi
    zoxide
    zellij
    zsh
  ] ++ (lib.optionals stdenv.isDarwin [ mas ]);

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh.enable = false;
  programs.git.enable = false;
  programs.home-manager.enable = true;
}
