{pkgs, username, ...}: {
  users.users.${username}.extraGroups = ["dialout" "uucp"];

  # DMS reads the profile picture from AccountsService.
  systemd.services.user-profile-picture = {
    description = "Set ${username}'s profile picture";
    wantedBy = ["multi-user.target"];
    requires = ["accounts-daemon.service"];
    after = ["accounts-daemon.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      user_object=$(${pkgs.systemd}/bin/busctl --system --json=short call \
        org.freedesktop.Accounts /org/freedesktop/Accounts \
        org.freedesktop.Accounts FindUserByName s ${pkgs.lib.escapeShellArg username} \
        | ${pkgs.jq}/bin/jq -r '.data[0]')
      ${pkgs.systemd}/bin/busctl --system call \
        org.freedesktop.Accounts "$user_object" \
        org.freedesktop.Accounts.User SetIconFile s ${./userpic.png}
    '';
  };
}
