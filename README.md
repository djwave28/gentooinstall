WARNING. 

The development of this install is not done. Use at own risk. 
Setting in the script should be checked and changed if you intend to use this.




# gentooinstall
gentoo installation script

Boot medium

mkdir -p /mnt/install

# mount the disk with install scripts
mount /dev/sdb4 /mnt/install

# cd to folder install scripts



This install is meant to be performed from an existing medium. Use a USB or disk. In this example the files
are stored in teh home folder of an existing linux installation on disk /dev/sdba.

Gentoo is installed on drive /dev/sda

Boot the Gentoo medium and create a mount point.

# mkdir -p /mnt/install

Mount the existinng medium with the install files.

# mount /dev/sdb4 /mnt/install
# cd /mnt/install/<user>/Documents/gentooinstall

Follow the intallation

# ./install.part1.sh
# ./chroot.sh
# ./install-part2.sh

The script will try to emerge into the gentoo @world, but may stop to accpet and merge a use flag. This will interupt the install and a restart od the emerge is needed

# ./emerge-world.sh

When done, the kernel needs to be installed. 
kernels can be found at: https://packages.gentoo.org/packages/sys-kernel/gentoo-sources

If none is specified gentoo will choose the default stable kernel.

# emerge --ask sys-kernel/gentoo-sources



#

