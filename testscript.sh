#!/bin/bash


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
