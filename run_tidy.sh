#!/bin/bash

: ${SPEC_INSTALL:?"Need to set SPEC_INSTALL to point to your SPECCPU2006 installation dir"}
: ${INST_LIB:?"Need to set INST_LIB to point to the directory where your libinstrumentation.so and instrumentation.bc are stored"}

CONFDIR=`readlink -f ./alloc-configs`
CURRENT=`pwd`

if [ -z "$1" ]
then
  cd $CONFDIR
  BENCHLIST=`ls | xargs readlink -f`
  cd $CURRENT
  echo "Running all benchmarks"
else
  TEMPLIST=$@
  BENCHLIST=""
  for TEMP in $TEMPLIST
  do
      TEMP_PATH=`find $CONFDIR -iname $TEMP | xargs readlink -f`
      BENCHLIST=$BENCHLIST" "$TEMP_PATH
  done
  echo "Running $BENCHLIST"
fi

mkdir ./results/
RESULT_BASE=`readlink -f ./results/`

cp speccfg/tidy_alloc.cfg $SPEC_INSTALL/config

cd $SPEC_INSTALL
source ./shrc

for BENCH_CONFIG in $BENCHLIST
do
    BENCH_NAME=${BENCH_CONFIG#$CONFDIR/}
    echo $BENCH_CONFIG
    echo $BENCH_NAME
    RESULT_DIR=$RESULT_BASE/${BENCH_NAME}_`date +%y%m%d_%H%M%S`
    mkdir -p $RESULT_DIR

    export ALLOC_IN=$BENCH_CONFIG
    runspec --action=scrub $BENCH_NAME
    LD_LIBRARY_PATH=$TIDY_ROOT/lib runspec --config=tidy_alloc --size=train --noreportable $BENCH_NAME | tee $RESULT_DIR/output.log
    TIMING=`cat $RESULT_DIR/output.log | grep "format: ASCII" | awk '{print $4}'`
    cp $TIMING $RESULT_DIR/all_timing.txt
    cat $TIMING | grep $BENCH_NAME | grep "VE" | grep -v "\#" > $RESULT_DIR/timing.txt
    pwd
    rm $CURRENT/results/latest -rf
    mkdir $CURRENT/results/latest
    cp $RESULT_DIR/* $CURRENT/results/latest -R
done































































