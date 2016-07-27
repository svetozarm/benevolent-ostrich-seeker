#!/bin/bash

files=`find braid_results -iname "*json"`

for f in $files
do
    ./process_braid_profiling.py $f 
done
