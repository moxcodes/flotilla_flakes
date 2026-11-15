{meta_conf}: {
  config,
  pkgs,
  lib,
  ...
}@args: let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Colloid-Green-Dark-Compact'
      gsettings set $gnome_schema icon-theme 'Colloid'
      gsettings set $gnome_schema font-name 'InconsolataNerdFont 8'
      gsettings set $gnome_schema document-font-name 'InconsolataNerdFont 8'
      gsettings set $gnome_schema monospace-font-name 'InconsolataNerdFont 8'
    '';
  };
in
{
  imports = [
    # program modules/extensions
    ./modules/python_manager.nix

    # personal config factoring
    ((import ./backend_dev_edc.nix {custom = meta_conf; }) args)
    ((import ./shell.nix {custom = meta_conf; }) args)
  ] ++ lib.optionals (!meta_conf.headless) [
    ((import ./coms.nix {custom = meta_conf; }) args)
    ((import ./media.nix {custom = meta_conf; }) args)
    ((import ./graphical.nix {custom = meta_conf; }) args)
  ];
  python_manager = with pkgs; {
    enable = true;
    python = python3;
    python_packages = [
      "google-api-python-client"
      "google-auth-httplib2"
      "google-auth-oauthlib"
      "websocket-client"
    ];
  };
  home.packages = with pkgs; [
    age
    awscli2
    alsa-utils
    dmidecode
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
    mplayer
    silver-searcher-ng
    syncthing
    yt-dlp
  ];

  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

}

