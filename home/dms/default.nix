{
  config,
  lib,
  pkgs,
  ...
}:
let
  preferences = import ./preferences.nix;
  settings = pkgs.writeText "dms-settings.json" (builtins.toJSON (preferences.settings // {
    # First-boot fallback only. Existing bars and their layout are kept below.
    barConfigs = [{
      id = "default";
      name = "Main Bar";
      enabled = true;
      position = 0;
      screenPreferences = [ "all" ];
      showOnLastDisplay = true;
      leftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
      centerWidgets = [ "music" "clock" "weather" ];
      rightWidgets = [ "systemTray" "clipboard" "cpuUsage" "memUsage" "notificationButton" "battery" "controlCenterButton" ];
    }];
  }));
  session = pkgs.writeText "dms-session.json" (builtins.toJSON preferences.session);
in
{
  # DMS writes these files itself; merge declared preferences on each activation.
  home.activation.dmsPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    merge_dms_config() {
      local target="$1" defaults="$2" configure_bars="$3" temporary existing
      if [[ -v DRY_RUN ]]; then
        verboseEcho "Would merge DMS preferences into $target"
        return
      fi
      run mkdir -p "$(dirname "$target")"
      temporary=$(mktemp "$(dirname "$target")/.dms-XXXXXX")
      existing="$defaults"
      if [ -f "$target" ]; then
        existing="$target"
      fi
      ${pkgs.jq}/bin/jq -s \
        --argjson configureBars "$configure_bars" \
        --argjson appearance ${lib.escapeShellArg (builtins.toJSON preferences.topBarAppearance)} \
        '
          # Remove the previously managed insets from existing bars.
          def without_edge_spacers:
            map(select(if type == "object" then .nixosEdgeInset != true else true end));
          .[0] as $existing |
          ($existing * .[-1]) |
          if $configureBars then
            .barConfigs = (($existing.barConfigs // .barConfigs) | map(
              if (.position // 0) == 0 then
                . * $appearance |
                .leftWidgets = ((.leftWidgets // []) | without_edge_spacers) |
                .rightWidgets = ((.rightWidgets // []) | without_edge_spacers)
              else . end
            ))
          else . end
        ' "$existing" "$defaults" > "$temporary"
      run mv "$temporary" "$target"
    }
    merge_dms_config ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"} ${settings} true
    merge_dms_config ${lib.escapeShellArg "${config.xdg.stateHome}/DankMaterialShell/session.json"} ${session} false
  '';
}
