#!/bin/bash

cat   <<EOF 

# You have reached the end of step 1

From this point it is possible to continue. There is no need to 
go back to the very start.

At this point there is two things that can be done


# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.


CHOST="x86_64-pc-linux-gnu" 
COMMON_FLAGS="-march=sandybridge -O2 -pipe"



EOF

echo $scrtext
