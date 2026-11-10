{config, username, ...}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # Keep this at the release used when Home Manager was introduced.
    stateVersion = "25.05";
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };

  programs.home-manager.enable = true;
}
