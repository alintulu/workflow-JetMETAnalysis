#!/bin/sh

WorkDir=$1
Output=$2
CodeDir=$3

hadd -k -f output_ak4pf.root $Output

cd $CodeDir

jet_synchfit_x \
   -inputDir  $WorkDir \
   -outputDir $WorkDir \
   -algo1 ak4pf \
   -algo2 ak4pf \
   -highPU false \
   -useNPU false \
   -functionType standard \
   -era ParallelMCPreDeriveL1