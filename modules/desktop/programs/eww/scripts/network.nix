{ config, lib, pkgs, ... }:

{
  modules.scripts.network = pkgs.writeScriptBin "network" ''
    #!/usr/bin/env python
    import json
    import os
    import sys

    # Get interfaces
    def e(command): 
        return os.popen(command).read()[:-1]

    only_interface = False
    custom_display = False

    if len(sys.argv) > 1:
        if sys.argv[1] == "interface":
            only_interface = True
        elif sys.argv[1] == "custom":
            if len(sys.argv) < 3:
                print("Need second arg as JSON")
                sys.exit()
            else:
                custom_display = json.loads(sys.argv[2])

    interfaces = e('nmcli -t device | grep ":connected:"')
    interfaces = interfaces.split("\n")

    connected_interfaces = []

    if interfaces != [""]:
        for interface in interfaces:
            interface = interface.split(":")

            connected_interfaces.append({
                "ifname" : interface[0],
                "type" : interface[1],
                "state" : interface[2],
                "name" : interface[3]
            })

    def getInterface():
        connected = False

        if not only_interface:
            for interface in connected_interfaces:
                connected = True
                if interface["type"] == "wifi":
                    return interface["name"]

        for interface in connected_interfaces:
            connected = True
            return interface["ifname"]

        if not connected:
            return "disconnected"

    if custom_display == False:
        print(getInterface())
    else:
        connected = False
        for interface in connected_interfaces:
            connected = True
            if interface["type"] == "wifi":
                print(custom_display["wifi"])
            elif interface["type"] == "ethernet":
                print(custom_display["ethernet"])
        if not connected:
            print(custom_display["disconnected"])
  '';
}

