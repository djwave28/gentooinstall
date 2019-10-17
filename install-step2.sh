#!/bin/bash


mount /dev/sda1 /boot


emerge-webrsync
read -p "Press enter to continue"
eselect news list 


read -p "Press enter to continue"

cat  <<EOF 
Next choose the profiles 

EOF


eselect profile list > file.txt

#sed -i '1d' file.txt
mapfile -t myArray < file.txt
#declare -n new_array=my_databases

unset myArray[0]

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
clear
cat <<EOF
##########################################################################
#
# Next we emerge into the Gentoo @world
#
# You will be sked to update use flags. Please read into this subject
# in teh handbook.
# To start it is OK to do so. After you choose yes, you must also 
# merg the changes with 
# 
# > etc-update
#
##########################################################################
EOF



emerge --ask --verbose --update --deep --newuse @world

etc-update
