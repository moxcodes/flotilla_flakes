{custom}: {
  config,
  pkgs,
  ...
}: {
  imports = [
    # program modules/extensions
    ./modules/python_manager.nix
  ];
  # python every day carry
  python_manager = with pkgs; {
    enable = true;
    python = lib.mkDefault python3;
    python_packages = [
      "beautifulsoup4"
      "numpy"
      "pandas"
      "pyusb"
      "selenium"
    ];
  };
  home.packages = with pkgs; [
    cargo
    clang
  ];
}
