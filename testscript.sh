#!/bin/bash


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
		tar xpvf $opt --xattrs-include='*.*' --numeric-owner -C ./unpack
	    break
            fi

            # 
           # break
            ;;
     esac

done
