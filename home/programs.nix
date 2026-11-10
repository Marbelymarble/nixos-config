{
  pkgs,
  config,
  inputs,
  username,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs; [
    # CLI and desktop utilities.
    zip
    unzip
    p7zip
    ripgrep
    yq-go
    htop
    libnotify
    xdg-utils
    graphviz
    pavucontrol
    playerctl
    pulsemixer
    imv
    helix
    deadnix
    nil
    nixfmt
    statix

    # Development and local services.
    docker-compose
    rustup
    ollama

    # Desktop applications.
    localsend
    wineWow64Packages.wayland
    obsidian
    unstable.vscode
    mangohud
    discord
    telegram-desktop
    xwayland-satellite
    qbittorrent
    prismlauncher
    kicad
    openscad
    orca-slicer
    signal-desktop
  ];

  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings.git_protocol = "https";
    };

    kitty = {
      enable = true;
      settings = {
        background_opacity = "0.75";
        background_blur = 1;
        dynamic_background_opacity = true;
      };
    };

    chromium = {
      enable = true;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
    };

    firefox = {
      enable = true;
      profiles.${username} = {};
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      extraConfig = "mouse on";
    };

    bat = {
      enable = true;
      config.pager = "less -FR";
    };

    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };

    obs-studio.enable = true;
    btop.enable = true;
    eza.enable = true;
    jq.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
    aria2.enable = true;
  };

  services = {
    syncthing.enable = true;
    udiskie.enable = true;
    playerctld.enable = true;
  };

  # Mirrors the previously hand-written user unit, but uses the Nix package path.
  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama local model server";
      Wants = ["network-online.target"];
      After = ["network-online.target"];
    };
    Service = {
      Environment = [
        "OLLAMA_HOST=127.0.0.1:11434"
        "OLLAMA_NO_CLOUD=1"
      ];
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = ["default.target"];
  };
}
