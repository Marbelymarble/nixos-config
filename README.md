My NixOS config.

AI was used to help organize and clean up this repository.

On a fresh x86_64 NixOS installation with UEFI, run as user `mari` with sudo access.

Clone (Git is provided temporarily):

```sh
nix-shell -p git --run 'git clone https://github.com/Marbelymarble/nixos-config.git "$HOME/nixos-config"'
cd "$HOME/nixos-config"
```

Use this machine's hardware configuration:

```sh
cp /etc/nixos/hardware-configuration.nix hosts/nixos/hardware-configuration.nix
```

Build and activate, enabling flakes for the first run:

```sh
sudo nixos-rebuild switch --flake .#marilaptop --option experimental-features 'nix-command flakes'
sudo reboot
```

After logging back in, rebuild future changes from Fish with:

```fish
nrs
```
