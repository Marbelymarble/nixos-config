{ pkgs, ... }:
let
  preferences = import ../home/dms/preferences.nix;
  settings = pkgs.writeTextDir "settings.json" (builtins.toJSON preferences.settings);
  session = pkgs.writeTextDir "session.json" (builtins.toJSON preferences.session);
in
{
  # Disable GDM without uninstalling GNOME.
  services.displayManager.gdm.enable = false;

  # Enable the DMS greeter.
  services.displayManager.dms-greeter = {
    enable = true;

    # Run the login screen using Niri.
    compositor.name = "niri";

    # Use the same declared appearance and wallpaper, including on first boot.
    configFiles = [
      "${settings}/settings.json"
      "${session}/session.json"
    ];
  };
}
