{
  config,
  lib,
  pkgs,
  ...
}:
let
  preferences = import ./preferences.nix;
  settings = pkgs.writeText "dms-settings.json" (builtins.toJSON preferences.settings);
  session = pkgs.writeText "dms-session.json" (builtins.toJSON preferences.session);
in
{
  # DMS writes these files itself; merge declared preferences on each activation.
  home.activation.dmsPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    merge_dms_config() {
      local target="$1" defaults="$2" temporary
      if [[ -v DRY_RUN ]]; then
        verboseEcho "Would merge DMS preferences into $target"
        return
      fi
      run mkdir -p "$(dirname "$target")"
      temporary=$(mktemp "$(dirname "$target")/.dms-XXXXXX")
      if [ -f "$target" ]; then
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$defaults" > "$temporary"
      else
        cp "$defaults" "$temporary"
      fi
      run mv "$temporary" "$target"
    }
    merge_dms_config ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"} ${settings}
    merge_dms_config ${lib.escapeShellArg "${config.xdg.stateHome}/DankMaterialShell/session.json"} ${session}
  '';
}
