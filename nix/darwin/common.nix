{ pkgs, ... }: {
  system.stateVersion = 6;
  nix.enable = false;

  programs.zsh.enableCompletion = false;

  homebrew = {
    enable = true;
    casks = [];
  };
}
