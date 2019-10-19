#!/bin/bash

# Copying DNS info
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

cd /mnt/gentoo


# Mounting the necessary filesystems
if mountpoint -q /mnt/gentoo/proc; then
    echo "/proc is mounted"
else
    mount --types proc /proc /mnt/gentoo/proc
fi


if mountpoint -q /mnt/gentoo/sys; then
    echo "/sys is mounted"
else
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
fi


if mountpoint -q /mnt/gentoo/dev; then
    echo "/dev is mounted"
else
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev
fi



chroot /mnt/gentoo /bin/bash
source /etc/profile

# this does not work from a running script.
export PS1="(chroot) ${PS1}"
