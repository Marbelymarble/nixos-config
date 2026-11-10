{...}: {
  # DMS keeps its generated Niri fragments separate from the main config.
  xdg.configFile = {
    "niri/config.kdl".source = ./config.kdl;
    "niri/dms/alttab.kdl".source = ./dms/alttab.kdl;
    "niri/dms/binds.kdl".source = ./dms/binds.kdl;
    "niri/dms/cursor.kdl".source = ./dms/cursor.kdl;
    "niri/dms/layout.kdl".source = ./dms/layout.kdl;
    "niri/dms/outputs.kdl".source = ./dms/outputs.kdl;
    "niri/dms/windowrules.kdl".source = ./dms/windowrules.kdl;
    "niri/dms/wpblur.kdl".source = ./dms/wpblur.kdl;
  };
}
