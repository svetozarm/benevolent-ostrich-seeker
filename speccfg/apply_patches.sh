#!/bin/bash

PATCH_DIR=`pwd`
cd $SPEC_INSTALL/benchspec

if [ "$1" = "tidy" ]
then
    echo "Setting up patches for tidy"
    patch -p0 -R < $PATCH_DIR/makefile_llvmtrack.patch
    patch -p0 < $PATCH_DIR/makefile_tidy.patch
fi

if [ "$1" = "llvmtrack" ]
then
    echo "Setting up patches for llvmtrack"
    patch -p0 -R < $PATCH_DIR/makefile_tidy.patch
    patch -p0 < $PATCH_DIR/makefile_llvmtrack.patch
fi


