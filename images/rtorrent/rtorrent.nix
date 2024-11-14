{
  pkgs ? import <nixpkgs> { },
}:
pkgs.dockerTools.buildImage {
  name = "rtorrent";
  tag = "latest";
  copyToRoot = pkgs.stdenvNoCC.mkDerivation {
    name = "rtorrent-root";
    dontUnpack = true;
    buildPhase = ''
mkdir -p $out/etc/rtorrent
cp ${./}/rtorrent.rc $out/etc/rtorrent/rtorrent.rc
'';
  };
}
