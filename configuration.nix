{ pkgs, ... }:
{
  boot.loader.grub = {
    enable = true;

    version = 1;

    device = "nodev";

    extraPerEntryConfig = "root (hd0)";
  };

  boot.initrd.kernelModules = [ "xen_blkfront" ];

  networking.hostName = "linode.shealevy.com";

  fileSystems."/" = {
    fsType = "tmpfs";
    device = "tmpfs";
    options = "defaults,mode=755";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    label = "NixOS";
    fsType = "btrfs";
    options = "defaults,subvol=/nix";
  };

  fileSystems."/home" = {
    label = "NixOS";
    fsType = "btrfs";
    options = "defaults,subvol=/home";
    neededForBoot = true;
  };

  fileSystems."/var/lib/persistent-etc" = {
    label = "NixOS";
    fsType = "btrfs";
    options = "defaults,subvol=/var/lib/persistent-etc";
  };

  services.openssh = {
    enable = true;

    hostKeys = [ {
      path = "/var/lib/persistent-etc/ssh_host_rsa_key";

      type = "rsa";

      bits = 2048;
    } ];

    startWhenNeeded = true;
  };

  security.pam.enableSSHAgentAuth = true;

  users.mutableUsers = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    useChroot = true;
    extraOptions = "build-cores = 0";
    maxJobs = 4;
    readOnlyStore = true;
    trustedBinaryCaches = [ "http://hydra.nixos.org" ];
    package = pkgs.nixUnstable;
  };

  environment.systemPackages = with pkgs; [
    vim
    irssi
    tmux
    gnupg
    (pinentry.override { useGtk = false; })
    git
    autoconf automake libtool gettext
    gnumake
    gcc
    pkgconfig
    boehmgc
    nix-exec
  ];

  programs.bash.enableCompletion = true;

  users.extraUsers.shlevy = {
    createHome = true;
    description = "Shea Levy";
    group = "users";
    home = "/home/shlevy";
    isSystemUser = false;
    extraGroups = [ "wheel" ];
    useDefaultShell = true;
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];
    uid = 1000;
  };

  time.timeZone = "America/New_York";

  environment.etc."nixos/configuration.nix".source = "/home/shlevy/dotfiles/configuration.nix";

  environment.pathsToLink = [ "/share/aclocal" ];
}
