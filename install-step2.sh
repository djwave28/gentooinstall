#!/bin/bash


mount /dev/sda1 /boot


emerge-webrsync
read -p "Press enter to continue"
eselect news list 


read -p "Press enter to continue"

cat  <<EOF 
Next choose the profiles 

EOF


eselect profile list
