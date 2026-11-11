{ lib, pkgs, ... }:
let
  blue = "#5BCEFA";
  pink = "#F5A9B8";
  white = "#FFFFFF";
  frame = key: color: {
    type = "custom";
    inherit key;
    keyColor = color;
  };
  entry = type: icon: label: color: {
    inherit type;
    key = "│ {#${if color == pink then "38;2;245;169;184" else if color == white then "38;2;255;255;255" else "38;2;91;206;250"}}${icon} ${label}${lib.concatStrings (lib.replicate (7 - builtins.stringLength label) " ")} {#keys}│";
    keyColor = blue;
  };
in
{
  # The classic Nix snowflake ASCII, recoloured in horizontal trans flag bands.
  # Reference: https://github.com/dylanaraps/neofetch (nixos_old, MIT).
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "data";
        source = builtins.readFile ./fastfetch-logo.txt;
        color = {
          "1" = blue;
          "2" = pink;
          "3" = white;
        };
        padding = {
          top = 0;
          left = 2;
          right = 2;
        };
      };
      display = {
        separator = " ";
        color.keys = blue;
        color.output = white;
        percent.type = [ "num" ];
      };
      modules = [
        # ML4W's compact blue frame, with trans colours on the labels.
        # https://github.com/mylinuxforwork/dotfiles/blob/main/dotfiles/.config/fastfetch/config.jsonc
        (frame "╭───────────╮" blue)
        ((entry "title" "" "user" blue) // { format = "{user-name}"; })
        ((entry "title" "󰇅" "hname" blue) // { format = "{host-name}"; })
        (
          (entry "disk" "" "os age" blue)
          // {
            folders = "/";
            format = "{create-time:10} [{days} days ({years} years)]";
          }
        )
        (entry "uptime" "󰅐" "uptime" pink)
        ((entry "os" "" "distro" pink) // { format = "{name} {version-id}"; })
        (entry "kernel" "" "kernel" pink)
        (entry "wm" "" "wm" pink)
        (entry "terminal" "" "term" white)
        # Keep multiple monitors on one row as well.
        ((entry "command" "󰍹" "display" white) // {
          text = ''
            ${pkgs.fastfetch}/bin/fastfetch --config none --structure display --format json |
              ${pkgs.jq}/bin/jq -r '[.[] | .result[]? | .output | "\(.width)x\(.height) @ \(.refreshRate | round) Hz"] | if length == 0 then "Unknown" else join(", ") end'
          '';
        })
        (entry "shell" "" "shell" white)
        ((entry "cpu" "󰍛" "cpu" white) // { format = "{name:30}"; })
        (
          (entry "command" "󰢮" "gpu" pink)
          // {
            text = ''
              ${pkgs.fastfetch}/bin/fastfetch --config none --structure gpu --format json |
                ${pkgs.jq}/bin/jq -r '[.[] | select(.type == "GPU") | .result[] | .name | split("/")[0] | sub("[[:space:]]+$"; "")] | join(", ")'
            '';
            format = "{result:30}";
          }
        )
        (
          (entry "disk" "󰉉" "disk" pink)
          // {
            folders = "/";
            format = "{size-used} / {size-total} ({size-percentage})";
          }
        )
        (entry "memory" "" "memory" pink)
        (frame "├───────────┤" blue)
        ((entry "colors" "" "colors" blue) // {
          symbol = "circle";
        })
        (frame "╰───────────╯" blue)
      ];
    };
  };
}
