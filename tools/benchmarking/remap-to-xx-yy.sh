#!/bin/bash

set -eu
cd $1
# First we will deal with .git/annex/objects
for d in .git/annex/objects/??/??/*; do
    [ -d $d ] || continue
    chmod +w $d $d/..
    # although it must be the same name, let's be uber careful
    mv $d ${d}_
    mv ${d}_/* ${d}_/..
    rmdir ${d}_
    echo -n ,
done

# now remap all the symlinks
find -type l \
| while read f; do
   l=$(readlink "$f") 
   rm $f; ln -s ${l%/*} $f
   # check if link is not broken
   [ -e $f ] || { echo BROKEN; exit 999; }
   echo -n .
done
# make it again not writable
chmod -w -R .git/annex/objects/??
