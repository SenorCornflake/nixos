{ self, lib, ... }:

let
  inherit (self.attrs) filterMappedAttributes;
  inherit (builtins) readDir pathExists;
  inherit (lib) id hasPrefix hasSuffix removeSuffix nameValuePair mapAttrsToList filterAttrs attrValues concatLists mapAttrs';
in
rec {
  # All copied from hlissner's configs
  mapModules = directory: function:
    filterMappedAttributes
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString directory}/${n}"; in
        if v == "directory" && pathExists "${path}/default.nix"
        then nameValuePair n (function path)
        else if v == "regular" &&
                n != "default.nix" &&
                hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (function path)
        else nameValuePair "" null)
      (readDir directory);

  mapModulesList = directory: function:
    attrValues (mapModules directory function);

  mapModulesRec = directory: function:
    filterMappedAttributes
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString directory}/${n}"; in
        if v == "directory"
        then nameValuePair n (mapModulesRec path function)
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (function path)
        else nameValuePair "" null)
      (readDir directory);

  mapModulesRecList = directory: function:
    let
      dirs =
        mapAttrsToList
          (k: _: "${directory}/${k}")
          (filterAttrs
            (n: v: v == "directory" && !(hasPrefix "_" n))
            (readDir directory));
      files = attrValues (mapModules directory id);
      paths = files ++ concatLists (map (d: mapModulesRecList d id) dirs);
    in map function paths;
}
