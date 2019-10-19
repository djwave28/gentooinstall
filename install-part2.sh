#!/bin/bash


mount /dev/sda1 /boot


emerge-webrsync

read -p "Press enter to continue"

cat  <<EOF 
Next choose the profiles 

EOF


echo "America/Los_Angeles" > /etc/timezone
emerge --config sys-libs/timezone-data
clear
nano -w /etc/locale.gen
locale-gen

cat <<EOF > /etc/env.d/02locale
LANG="en_US.UTF-8"
LC_COLLATE="C"
EOF

nano /etc/env.d/02locale



# eselect locale list > locales.txt

locale-gen

eselect profile list > file.txt

#sed -i '1d' file.txt
mapfile -t myArray < file.txt
#declare -n new_array=my_databases

unset myArray[0]
clear
#for i in "${!myArray[@]}"; do printf "%d\t%s\n" $i "${myArray[i]}"; done

selectprofile ()
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
      echo "You selected option $REPLY"
      eselect profile set $REPLY
      break;
    else
      echo "Incorrect Input: Select a number 1-$#"
    fi
  done
}

selectprofile "${myArray[@]}"

emerge --ask sys-kernel/gentoo-sources
emerge --ask sys-apps/pciutils
clear
cat <<EOF
##########################################################################
#
# Next we emerge into the Gentoo @world
#
# If a question is asked abiut merging updates, choose -3.
#
# It is advised to read up on use flags dependencies fopr teh program 
# you're installing, but the initial install can;t be done without
# the first aceptance.
# Check the handbook for more on this subject.
#
# To accept and merge the changes issue following command:
# 
# > etc-update
# 
# Emerging your system can be a very long process depending on the 
# profile chosen. It can take up hours and it is advised to do this 
# when you can the computer for a long time
#
# If emereging gets interupted, it can be started again by running
#
# > ./emerge.world.sh
# 
##########################################################################
EOF

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
   emerge --ask --verbose --update --deep --newuse @world
   etc-update

#   emerge -v system/world/... --resume --verbose
#   FEATURES="keepwork" emerge whatever

else
    exit
fi

# 

# 