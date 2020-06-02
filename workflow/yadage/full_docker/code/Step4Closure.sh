#!/bin/sh --login

#BSUB -q 1nh

WorkDir=$1
Files=$2
CodeDir=$3

#hadd -k -f Input.root `echo $File | tr ':' ' '`

jet_correction_analyzer_x \
   -inputFilename $Files \
   -outputDir $WorkDir/ \
   -path $WorkDir/ \
   -era ParallelMC \
   -levels 1 2 \
   -useweight true \
   -algs ak4pf \
   -drmax 0.2 \
   -evtmax 0 \
   -nbinsrelrsp 200 \
   -relrspmin 0.0 \
   -relrspmax 2.0 \
   -MCPUReWeighting MyMCPileupHistogram.root \
   -DataPUReWeighting MyDataPileupHistogram.root \
   -nrefmax 3
