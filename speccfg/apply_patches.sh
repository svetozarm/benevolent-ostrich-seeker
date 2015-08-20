#!/bin/bash

PATCH_DIR=`pwd`
cd $SPEC_INSTALL/benchspec
patch -p0 < $PATCH_DIR/makefile_linkage.patch
