#!/bin/bash



mount /dev/sda4 /mnt/gentoo


# Installing a stage tarball

ntpd -q -g

cp install-step1.sh /mnt/gentoo
cp install-step2.sh /mnt/gentoo
cp chroot.sh /mnt/gentoo

cd /mnt/gentoo



links https://www.gentoo.org/downloads/mirrors/
read -p "Press enter to continue"

prompt="Please select a file:"
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
		# mkdir -p ./unpack
		tar xpvf $opt --xattrs-include='*.*' --numeric-owner
	    break
            fi
            ;;
     esac

done


read -p "Press enter to continue"

cat <<EOF > /mnt/gentoo/etc/portage/make.conf

# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
CHOST="x86_64-pc-linux-gnu" 
COMMON_FLAGS="-march=sandybridge -O2 -pipe"

# C compiler flags
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"

# fortran compiler flags
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"

MAKEOPTS="-j2" 

# NOTE: This stage was built with the bindist Use flag enabled
PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C

# Video Card
VIDEO_CARDS="radeon"

EOF

nano -w /mnt/gentoo/etc/portage/make.conf 
read -p "Press enter to continue"


# Chrooting

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
clear

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

clear


cat <<EOF 
"
If the Gentoo installation is interrupted anywhere after this point, it is
possible to 'resume' the installation at this step.

When resuming from this point, simply run the next step


# ./chroot.sh
# ./install-step2.sh


read the documentation for details "

EOF

read -p "Press enter to quit"



# ./chroot.sh


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


mount /dev/sda1 /boot


emerge-webrsync
read -p "Press enter to continue"
eselect news list 


read -p "Press enter to continue"

cat  <<EOF 
"Next choose the profiles "

EOF


eselect profile list > file.txt

#sed -i '1d' file.txt
mapfile -t myArray < file.txt
#declare -n new_array=my_databases

unset myArray[0]

#for i in "${!myArray[@]}"; do printf "%d\t%s\n" $i "${myArray[i]}"; done

createmenu ()
{
 # echo "Size of array: $#"
 # echo "$@"
  select option; do # in "$@" is the default
    if [ "$REPLY" -eq "$#" ];
    then
      echo "Exiting..."
      break;
    elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#-1)) ];
    then
      echo "You selected $option which is option $REPLY"
      break;
    else
      echo "Incorrect Input: Select a number 1-$#"
    fi
  done
}

createmenu "${myArray[@]}"


