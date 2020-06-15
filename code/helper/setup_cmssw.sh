#!/bin/bash

if [ $# -ne 2 ]; then
    echo 'Missing argument, expected CMSSW release and SCRAM ARCH version'
    exit 1
fi

RELEASE=$1
SCRAM_ARCH=$2

export SCRAM_ARCH=$SCRAM_ARCH
source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project CMSSW $RELEASE
cd $RELEASE/src
eval `scramv1 runtime -sh`
