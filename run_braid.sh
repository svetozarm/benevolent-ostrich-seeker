#!/bin/bash

: ${SPEC_INSTALL:?"Need to set SPEC_INSTALL to point to your SPECCPU2006 installation dir"}
: ${INST_LIB:?"Need to set INST_LIB to point to the directory where your libinstrumentation.so and instrumentation.bc are stored"}

BASEDIR=`pwd`
infile=`readlink -f $1`
CONFDIR=`readlink -f ./alloc-configs`

mkdir ./braid_results/
RESULT_BASE=`readlink -f ./braid_results/`

cp speccfg/braid.cfg $SPEC_INSTALL/config

cd $SPEC_INSTALL
source ./shrc

while read -a array
do
    BENCH_NAME=${array[0]}
    STRUCT=${array[1]}
    BENCH_CONFIG=${BASEDIR}/alloc-configs/${BENCH_NAME}/
    echo $BENCH_CONFIG
    echo $BENCH_NAME
    echo "CANDIDATE STRUCT "${STRUCT}
    RESULT_DIR=$RESULT_BASE/${BENCH_NAME}_`date +%y%m%d_%H%M%S`
    mkdir -p $RESULT_DIR

    export BRAID_STRUCT=${STRUCT}
    export ALLOC_IN=$BENCH_CONFIG
    runspec --action=scrub $BENCH_NAME
    LD_LIBRARY_PATH=$INST_LIB/../../llvm-access-instrumentation/StructInterleave/braidalloc/ runspec --config=braid --size=test --noreportable $BENCH_NAME | tee $RESULT_DIR/output.log

done < $infile

exit 


for BENCH_CONFIG in $BENCHLIST
do
    #BENCH_NAME=${BENCH_CONFIG#$CONFDIR/}
    echo $BENCH_CONFIG
    echo $BENCH_NAME
    RESULT_DIR=$RESULT_BASE/${BENCH_NAME}_`date +%y%m%d_%H%M%S`
    mkdir -p $RESULT_DIR

    export BRAID_STRUCTINFO=$RESULT_BASE/${BENCH_NAME}_structinfo.json
    export ALLOC_IN=$BENCH_CONFIG
    runspec --action=scrub $BENCH_NAME
    LD_LIBRARY_PATH=$INST_LIB/../../llvm-access-instrumentation/StructInterleave/braidalloc/ runspec --config=braid --size=test --noreportable $BENCH_NAME | tee $RESULT_DIR/output.log
done
