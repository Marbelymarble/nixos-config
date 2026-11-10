{config, username, ...}: {
  # Disable GDM without uninstalling GNOME.
  services.displayManager.gdm.enable = false;

  # Enable the DMS greeter.
  services.displayManager.dms-greeter = {
    enable = true;

    # Run the login screen using Niri.
    compositor.name = "niri";

    # Import this user's DMS appearance and wallpaper.
    configHome = config.users.users.${username}.home;
  };
}
