# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Allow unfree, which is required for some drivers.
  nixpkgs.config.allowUnfree= true;

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      # Define on which hard drive you want to install Grub.
      device = "/dev/sda"; # or "nodev" for efi only 
      # Adds any additional entries to the GRUB boot menu.
      extraEntries = '' 
      menuentry "Windows 10" {
        chainloader (hd0,1)+1
    }'';
  };
};

  networking.hostName = "nixos"; # Define your hostname.

  time = {
    timeZone = "America/Chicago";
    # Keeps hardware clock in local time to fix issues with Windows.
    hardwareClockInLocalTime = true;   
};

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:swapescape";

      windowManager.i3.enable = true;
      desktopManager.xterm.enable = false;

      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''
        feh --bg-scale ~/Desktop/Images/Sun.png &
        albert &
      '';
    };
  };

  compton = {
    enable = true;
    fade = true;
    backend = "xrender";
    inactiveOpacity = "0.75";
    activeOpacity = "0.90";
    opacityRules = [ "99:name *= 'Firefox'"];
  };
  
  redshift = {
    enable = true;
    latitude = "33";
    longitude = "-97";
    temperature.day = 6500;
    temperature.night = 2700;
  };
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.melody = {
    isNormalUser = true;
    home = "/home/melody";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker"];
    shell = pkgs.zsh;
  };

  virtualisation.docker.enable = true;

  programs = {
   zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    shellAliases = {
      l = "exa";
      ll = "exa -l";
      la = "exa -lah";
      vim = "nvim";
      dropbox = "docker exec -it dropbox dropbox";
      docker-start = ''
      docker run -d --restart=always --name=dropbox \
        -v /home/melody/Dropbox:/dbox/Dropbox \
        -v /home/melody/.dropbox:/dbox/.dropbox \
        -e DBOX_UID=1000 -e DBOX_GID=100 janeczku/dropbox'';
      };
      ohMyZsh = {
        enable = true;
        plugins = ["vi-mode" "web-search"];
        theme = "agnoster";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    environment.systemPackages = with pkgs; [
      alacritty
      emacs
      python3
      docker
      neovim
      firefox
      keepassxc
      albert
      ripgrep
      git
      wget
      aspell
      aspellDicts.en
      feh
      exa
      ranger
      fd
   ];

   fonts = {
      enableFontDir = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        hack-font
        source-code-pro
        powerline-fonts
        corefonts
        dejavu_fonts
        font-droid
        freefont_ttf
        google-fonts
         ubuntu_font_family
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
