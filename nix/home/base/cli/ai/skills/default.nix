targetDirectory:
let
  entries = builtins.readDir ./.;
  skillNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in
{
  home.file = builtins.listToAttrs (
    map (name: {
      name = "${targetDirectory}/${name}";
      value.source = ./. + "/${name}";
    }) skillNames
  );
}
