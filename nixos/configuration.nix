# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader - need
  # this because we're doing whole-disk encryption.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.intel.updateMicrocode = true;

  # TODO: one configuration.nix per machine, which imports
  # common stuff.
  networking.hostName = "stxps";
  networking.wireless.enable = true;

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";

    # English Language with sensible formatting
    defaultLocale = "en_DK.UTF-8";
  };

  # Set your time zone.
  services.timesyncd.enable = true; # the default, but explicitness is a good thing
  time.timeZone = "Europe/Vienna";

  # Allow non-free things like firefox-bin
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox-bin
    pavucontrol
    openssh
    git
    git-lfs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Start ssh-agent as a systemd user service
  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
	  enable = true;

      # Only pubkey auth
	  passwordAuthentication = false;
	  challengeResponseAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.allowPing = true;

  networking.firewall.allowedTCPPorts = [
    22 5060 30080 30443
  ];

  networking.firewall.allowedUDPPorts = [
    79 5060
  ];

  networking.firewall.allowedUDPPortRanges = [
    { from = 4000; to = 4100; }
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable passwd and co.
  users.mutableUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stears = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/stears";

	openssh.authorizedKeys.keys = [
		(import ./files/philip-pubkey.nix)
	];
  };

  programs.zsh.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
