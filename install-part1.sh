#!/bin/bash
clear

RED='\033[0;31m'
NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"


cat <<EOF
##########################################################################
# ${RED}THIS GUIDE WILL INSTALL A BASIC GENTOO SYSTEM
#
# FOR DETAILS VISIT https://www.gentoo.org/
#
##########################################################################
EOF


read -p "Step1 is downloading and installing the tarbal. Press enter to continue"
mount /dev/sda4 /mnt/gentoo

clear
echo "Wait for download mirror to load"
echo " "


# Installing a stage tarball

ntpd -q -g

cp install-part1.sh /mnt/gentoo
cp install-part2.sh /mnt/gentoo
cp emerge-world.sh /mnt/gentoo
cp install-kernel.sh /mnt/gentoo
cp cleanup.sh /mnt/gentoo
cp chroot.sh /mnt/gentoo
# cp make.conf /mnt/gentoo
# cp kernels.txt /mnt/gentoo

cp -avr ./tmpdir /mnt/gentoo/tmpdir

cd /mnt/gentoo



links https://www.gentoo.org/downloads/mirrors/

clear
# read -p "Press enter to continue"
echo " "
prompt="Please select the tarball file or other option:"
echo " "

options=( $(find -maxdepth 1 -print0 | xargs -0) )

PS3="$prompt "
select opt in "${options[@]}" "Quit" "Skip" ; do
    
    case $opt in
        'Skip')
            echo "skipping this step"
            break
        ;;
        'Quit')
            echo "quit and exit"
            exit
        ;;
        *)
            if ! { tar ztf "$opt" || tar tf "$opt"; } >/dev/null 2>&1; then
                echo "$opt is not a tar file"
            else
                tar xpvf $opt --xattrs-include='*.*' --numeric-owner
                break
            fi
        ;;
    esac
    
done

clear



cat <<EOF
##########################################################################
#
# The next step is setting the system flags. The settings are for
# an i7 CPU Sandy Bridge, Change as needed
#
##########################################################################
EOF

read -p "Press enter to continue"


value=`cat ./tmpdir/make.conf`
echo "$value" > /mnt/gentoo/etc/portage/make.conf


nano -w /mnt/gentoo/etc/portage/make.conf
clear

cat <<EOF
##########################################################################
#
# Next step is choosing download mirrors that we use to
# download packageds and updates. Choose mirrors that give
# a bbetter speed and download. Usually that will be the
# closets mirrors.
#
##########################################################################
EOF


read -p "Press enter to continue"


# Chrooting

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
clear

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

clear


cat <<EOF

If the Gentoo installation is interrupted anywhere after this point, it is
possible to 'resume' the installation at this step.

When resuming from this point, simply run the next step


> ./chroot.sh
> ./install-part2.sh


read the documentation for details

EOF

read -p "Press enter to quit"
exit






