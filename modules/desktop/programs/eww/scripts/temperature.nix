{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lm_sensors ];
  modules.scripts.temperature = pkgs.writeScriptBin "temperature" ''
    #!/usr/bin/env python

    import json
    import os

    def e(command): 
        return os.popen(command).read()[:-1]

    sensors = e("sensors -j")
    sensors = json.loads(sensors)
    sensors = sensors["coretemp-isa-0000"]

    temps = []

    for key in sensors:
        value = sensors[key]
        if isinstance(value, dict):
            for key in value:
                if "input" in key:
                    temps.append(value[key])

    print(round(sum(temps) / len(temps), 1))
  '';
}
