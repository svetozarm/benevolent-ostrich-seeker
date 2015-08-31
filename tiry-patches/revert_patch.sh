#!/bin/bash

CURRENT=`pwd`
: ${1:?"Please input benchmark name."}
BENCH=$1

PATCHDIR=$CURRENT/$BENCH

echo $PATCHDIR

cd $SPEC_INSTALL/benchspec/CPU2006

patch -p0 -R < $PATCHDIR/"$BENCH"_tidy.patch


