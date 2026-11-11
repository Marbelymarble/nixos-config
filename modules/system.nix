{
  pkgs,
  lib,
  username,
  ...
}: let
in {
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel"];
  };
  users.defaultUserShell = pkgs.fish;
  imports = [
    ./dms-greeter.nix
  ];
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      extra-substituters = ["https://nix-community.cachix.org"];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      builders-use-substitutes = true;
      trusted-users = ["root" username];
    };

    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      material-design-icons
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];

    # Put color emoji ahead of the monochrome fallback.
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # SSH opens its own port; other services currently rely on an open firewall.
  networking.firewall.enable = false;

  services = {
    printing.enable = true;
    power-profiles-daemon.enable = true;
    geoclue2.enable = true;
    dbus.packages = [pkgs.gcr];
    udev.packages = [pkgs.gnome-settings-daemon];

    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = ["com.usebottles.bottles"];
      # Update explicitly with `flatpak update --system`, outside rebuilds.
      update = {
        onActivation = false;
        auto.enable = false;
      };
      uninstallUnmanaged = true;
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;

  programs = {
    dconf.enable = true;
    fish.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # System administration and development.
    vim
    wget
    curl
    git
    fastfetch
    python3
    gcc

    # Desktop and device integration.
    libreoffice-qt
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    libimobiledevice
    ifuse
  ];
}
