{ config, pkgs, lib, ... }:
{
  config = lib.mkIf (builtins.currentSystem == "aarch64-linux") {
    fileSystems = {
      #"/boot" = {
      #  device = "/dev/disk/by-label/NIXOS_BOOT";
      #  fsType = "vfat";
      #};
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };
    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_rpi; #_latest;
    boot.kernelParams = [
          "cma=256M"
          "video=HDMI-A-1:2200x1650@30"
          #"drm_kms_helper.edid_firmware=edid/1600x1200.bin"
          #"drm.edid_firmware=edid/1600x1200.bin"
    ];
    #hardware.firmware = [
    #      (pkgs.runCommand "foo" {} "mkdir -pv $out/firmware/edid/1600x1200.bin; cp ${./1600x1200.bin} $out/firmware/edid/1600x1200.bin")
    #];

    services.sshd.enable = true;
    services.openssh.permitRootLogin = "yes";

    boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

    services.xserver.videoDrivers = [ "fbdev" ]; #modeset
    services.jack.jackd.enable = false;
  };
}
