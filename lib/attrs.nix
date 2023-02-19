{ self, lib, ... }:

let
  inherit (lib) mapAttrs' filterAttrs;
in

{
  # Map an attribute set by looping over it and executing a function on each element, then filter the result.
  # mapAttrs' is like mapAttrs but allows you to change both the key and value of an element instead of just the value
  filterMappedAttributes = predicate: function: attributes: filterAttrs predicate (mapAttrs' function attributes);
}
