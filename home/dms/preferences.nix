let
  wallpaper = "${../../wallpapers}/MossOnBridge.jpg";
in
{
  settings = {
    currentThemeName = "dynamic";
    currentThemeCategory = "dynamic";
    matugenScheme = "scheme-tonal-spot";
    use24HourClock = true;
    useFahrenheit = false;
    windSpeedUnit = "kmh";
    niriLayoutGapsOverride = 3;
    wallpaperFillMode = "Fill";
    greeterWallpaperPath = wallpaper;
    fontFamily = "Inter Variable";
    monoFontFamily = "Fira Code";
    showDock = false;
    acMonitorTimeout = 900;
    acLockTimeout = 600;
    acSuspendTimeout = 0;
    gtkThemingEnabled = false;
    qtThemingEnabled = false;
  };

  session = {
    wallpaperPath = wallpaper;
    perMonitorWallpaper = false;
    perModeWallpaper = false;
    wallpaperCyclingEnabled = false;
    wallpaperTransition = "fade";
    isLightMode = false;
  };
}
