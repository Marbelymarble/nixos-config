{
  config,
  lib,
  pkgs,
  ...
}: let
  solidcraftVersion = "0.40.0-rc.2";
  solidcraftSha256 = "e57ac4c5bfbeba1c146a86524110b5973ce1848b7ef8dce2d2d77b3a3d651c17";
  lightcraftVersion = "0.18.1";
  lightcraftSha256 = "311cc51abcacab908bd70a6d2fc04742d15cab6ca563ccc874956964ea1c5195";
in {
  imports = [
    ../../home/core.nix
    ../../home/programs.nix
    ../../home/nixos-config.nix
    ../../home/niri
    ../../home/dms
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Mari Schnabel";
      email = "mari@mschnabel.com";
    };
  };

  # Preserve the existing user-specific Fish helpers without hard-coding /home/mari.
  programs.fish.functions = {
    letgo = {
      description = "Run the local letgo TUI";
      body = ''
        python3 ${lib.escapeShellArg "${config.home.homeDirectory}/letgo/letgo-tui/run"} $argv
      '';
    };
    venting = {
      description = "Run the local venting application";
      body = ''
        python3 ${lib.escapeShellArg "${config.home.homeDirectory}/Documents/venting/run"} $argv
      '';
    };
  };

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "chatgpt";
        location = "https://rulin132.github.io/chatgpt-flatpak/repo/";
      }
    ];

    packages = [
      rec {
        appId = "io.tangencylabs.solidcraft";
        sha256 = solidcraftSha256;
        # This release candidate is newer than the official stable Flatpak feed.
        bundle = "${pkgs.fetchurl {
          url = "https://github.com/tangency-labs/solidcraft/releases/download/v${solidcraftVersion}/solidcraft-${solidcraftVersion}-linux-x86_64.flatpak";
          inherit sha256;
        }}";
      }
      {
        appId = "io.github.rulin132.ChatGPT";
        origin = "chatgpt";
      }
      rec {
        appId = "ai.storyteller.lightcraft";
        sha256 = lightcraftSha256;
        # LightCraft has no Flatpak remote; bump the version and hash together.
        bundle = "${pkgs.fetchurl {
          url = "https://github.com/storytold/lightcraft/releases/download/v${lightcraftVersion}/lightcraft-${lightcraftVersion}-linux-x86_64.flatpak";
          inherit sha256;
        }}";
      }
    ];

    update.onActivation = true;
    uninstallUnmanaged = true;
    uninstallUnused = true;
  };
}
