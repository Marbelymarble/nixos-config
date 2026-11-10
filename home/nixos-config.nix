{
  config,
  lib,
  ...
}: {
  options.mari.nixosConfig.repository = lib.mkOption {
    type = lib.types.strMatching "^/.*";
    default = "${config.home.homeDirectory}/nixos-config";
    description = "Absolute path to the editable NixOS configuration checkout.";
  };

  config.programs.fish = {
    enable = true;
    functions.nrs = {
      description = "Rebuild and switch the NixOS configuration for this host";
      body = ''
        set -l config_repo ${lib.escapeShellArg config.mari.nixosConfig.repository}
        set -l current_host (hostname)
        or return
        sudo nixos-rebuild switch --flake "$config_repo#$current_host" $argv
      '';
    };
  };
}
