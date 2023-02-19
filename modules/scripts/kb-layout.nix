{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeScriptBin "kb_layout" ''
      #!${pkgs.python3Full}/bin/python

      import os

      def getLayout(name, layouts):
          for layout in layouts:
              if layout["name"] == name:
                  return layout

      layouts = [
          "us",
          "ara",
          "dvorak",
          "dvp",
      ]

      layouts = [
          { 
              "name": "US QWERTY",
              "layout": "us",
              "variant": "\"\""
          },
          { 
              "name": "US DVORAK Programmer",
              "layout": "us",
              "variant": "dvp"

          },
          { 
              "name": "US DVORAK",
              "layout": "us",
              "variant": "dvorak"
          },
          { 
              "name": "ARA QWERTY",
              "layout": "ara",
              "variant": "qwerty"
          }
      ]

      cmd = 'echo "{}" | ${pkgs.tofi}/bin/tofi --prompt-text "Layout: "'.format("\n".join([layout["name"] for layout in layouts]))

      layout = os.popen(cmd).read()[:-1]

      if layout != "":
          variant = getLayout(layout, layouts)["variant"]
          layout = getLayout(layout, layouts)["layout"]

          os.system("${pkgs.hyprland}/bin/hyprctl keyword input:kb_layout {}".format(layout))
          os.system("${pkgs.hyprland}/bin/hyprctl keyword input:kb_variant {}".format(variant))
    '')
  ];
}
