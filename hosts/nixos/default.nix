{pkgs, ...}: {
  imports = [
    ../../modules/system.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "marilaptop";
    networkmanager.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
    desktopManager.gnome.enable = true;
    usbmuxd.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs = {
    niri.enable = true;
    dms-shell.enable = true;
    gamemode.enable = true;

    # Libraries available to unpackaged dynamically linked binaries.
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        libgcc
        glib
      ];
    };
  };

  # Keep this at the release used for the original installation.
  system.stateVersion = "25.05";
}
