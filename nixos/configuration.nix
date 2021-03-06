# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # Allows unfree, which is required for some drivers.
  nixpkgs.config.allowUnfree = true; 
  
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      version = 2;
      enable = true;
      useOSProber = true;
  };
};

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.devices = [ "nodev" ];
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.useOSProber = true;

    networking.hostName = "LesserGremlin"; # Define your hostname.

  # Set your time zone.
  time = {
    timeZone = "America/Chicago";
    # Keeps hardware clock in lcoal time to fix issues with Windows
    hardwareClockInLocalTime = true;
};

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  

  # Enable the X11 windowing stystem
  services = {
    syncthing = {
	enable = true;
	user = "Melody";
	dataDir = "/home/melody/Documents";
	configDir = "/home/melody/Documents/.config/syncthing";
    };

    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:swapescape";
      
      windowManager.i3.enable = true;
      desktopManager.xterm.enable = false;

      videoDrivers = [
        "nvidiaBeta"
      ];

      screenSection = ''
        Option "metamodes" "2560x1440_120 +0+0"
      '';

      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''
        # feh --bg-scale ~/Desktop/Images/Sun.png &
        albert &
      '';
    };
  };

  compton = {
    enable = true;
    fade = true;
    backend = "xrender";
    inactiveOpacity = 0.75;
    activeOpacity = 0.90;
    opacityRules =  ["99:name *= 'Firefox'"];
  };
};

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.melody = {
    isNormalUser = true;
    home = "/home/melody";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    environment.systemPackages = with pkgs; [
      syncthing
      wget 
      vim
      firefox
      alacritty
      emacs
      python3
      keepassxc
      albert
      ripgrep
      git
      aspell
      aspellDicts.en
      feh
      exa
      ranger
      google-chrome
      rustc
      gcc
      cargo
      fd
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  fonts = {
     enableFontDir = true;
     enableGhostscriptFonts = true;
     fonts = with pkgs; [
       hack-font
       source-code-pro
       powerline-fonts
       corefonts
       dejavu_fonts
       freefont_ttf
       google-fonts
       ubuntu_font_family
   ];
 };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

