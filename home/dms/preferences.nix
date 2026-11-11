let
  wallpaper = "${../../wallpapers}/MossOnBridge.jpg";
  # Match the existing Niri window geometry in home/niri/dms/layout.kdl.
  windowRadius = 20;
  windowGap = 10;
in
{
  settings = {
    currentThemeName = "dynamic";
    currentThemeCategory = "dynamic";
    matugenScheme = "scheme-tonal-spot";
    use24HourClock = true;
    useFahrenheit = false;
    windSpeedUnit = "kmh";
    cornerRadius = windowRadius;
    niriLayoutRadiusOverride = windowRadius;
    niriLayoutGapsOverride = windowGap;
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

  # Applied to top bars individually, preserving widgets and monitor assignments.
  topBarAppearance = {
    spacing = windowGap;
    innerPadding = 4;
    transparency = 0.7;
    widgetTransparency = 1.0;
    squareCorners = false;
    noBackground = false;
  };

  session = {
    wallpaperPath = wallpaper;
    perMonitorWallpaper = false;
    perModeWallpaper = false;
    wallpaperCyclingEnabled = false;
    # DMS's native crossfade is 1000 ms with InOutCubic easing (1.4.6).
    wallpaperTransition = "fade";
    isLightMode = false;
  };
}
