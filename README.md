Ultrazed Zynq SoCFPGA Development

Tools Required:
Xilinx Vivado/SDK 2017.4
Xilinx Petalinx 2017.4
Git LFS - https://help.github.com/articles/installing-git-large-file-storage/

More Info / Instructions:
https://www.twosixlabs.com/ubuntu-on-ultrazed-embedded-high-performance-computing/

Configure Vivado / Petalinux install directories, install Ubuntu 16.04.3 build dependencies and copy Vivado board files:
1. source ./scripts/eng_setup.sh --vivado INSTALL_DIR --petalinux INSTALL_DIR --install

Build all:
1. source ./scripts/env_setup.sh
2. make all && make install

Create tarball of SD card partitions:
1. Run the SD write script in the scripts directory: './wr_tarball.sh --tar FILENAME

Image your SD card for SD boot:
1. Insert the SD card and unmount it
2. Run the SD write script in the scripts directory: './wr_sdcard.sh --dev YOUR_DEVICE --part'

Image your SD card for eMMC boot:
1. Insert the SD card and unmount it
2. Run the SD write script in the scripts directory: './wr_sdcard.sh --dev YOUR_DEVICE --part --mmc'

First time boot instructions - SD Card:
1. Configure your UltraZed SOM to boot from theh SD card
2. Press any key to break into uBoot
3. Reset the uBoot environment to defaults: 'env default -f -a'
4. Set the SD device environment variable to default to the SD card: 'env set sd_dev 1'
5. Save the uBoot environment to QSPI: 'env save'
6. Boot the system: 'boot'

First time boot instructions - eMMC:
1. Configure your UltraZed SOM to boot from theh SD card
2. Press any key to break into uBoot
3. Reset the uBoot environment to defaults: 'env default -f -a'
4. Save the uBoot environment to QSPI: 'env save'
5. Run the SD boot command: 'run sd_boot'
6. Login as zynqmp, then switch to root with su.
7. Switch to /root and image the eMMC with the wrtie eMMC script: './wr_mmc.sh --dev /dev/mmcblk0'
8. Power off and configure your Ultrazed SOM to boot from eMMC
9. Power on.  The system should now boot from the eMMC
