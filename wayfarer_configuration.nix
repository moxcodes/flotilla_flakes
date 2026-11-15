# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./wayfarer_hardware_configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "wayfarer";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.nvidia.open = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.gnome.gcr-ssh-agent.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mox = {
    isNormalUser = true;
    description = "Jordan Moxon";
    extraGroups = ["docker" "networkmanager" "video" "wheel" "disk"];
    openssh.authorizedKeys.keyFiles = [
      ./ssh/authorized_keys
    ];
    shell = pkgs.fish;
   };

  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  # nixpkgs.config.cudaSupport = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    cargo
    clang
    docker
    fish
    fuse3
    git
    glib
    tuigreet
    gparted
    lm_sensors
    lshw
    ntfs3g
    pciutils
    pv
    rustc
    sshfs
    sshfs-fuse
    sway
    wget
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
  ];

  programs.fish.enable = true;

  programs.ssh.startAgent = true;
  services.openssh.enable = true;
  programs.fuse.userAllowOther = true;
  security.wrappers.fusermount3 = {
    owner = "root";
    group = "root";
    setuid = true;
    source = "${pkgs.fuse3}/bin/fusermount3";
  };  
  services.openssh.settings.PasswordAuthentication = false;
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;

  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedTCPPorts = [
      # Syncthing ports (gui and sync protocol) - for mox
      8384
      22000
    ];
    allowedUDPPorts = [
      # Syncthing ports (sync protocol) - for mox
      22000
      21027
      config.services.tailscale.port
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
