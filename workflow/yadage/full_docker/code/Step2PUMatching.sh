#!/bin/sh --login

#BSUB -q 1nh

WorkDir=$1
NoPUFile=$2
PUFile=$3
CodeDir=$4

hadd -f -k NoPUFile.root `echo $NoPUFile | tr ':' ' '`
hadd -f -k PUFile.root `echo $PUFile | tr ':' ' '`

cd $CodeDir

jet_synchtest_x \
   -basepath $WorkDir \
   -samplePU PUFile.root \
   -sampleNoPU NoPUFile.root \
   -algo1 ak4pf \
   -algo2 ak4pf \
   -iftest false \
   -maxEvts 10000000 \
   -ApplyJEC false \
   -outputPath $WorkDir \
   -npvRhoNpuBinWidth 10 \
   -NBinsNpvRhoNpu 6 \
   -MCPUReWeighting MyMCPileupHistogram.root \
   -DataPUReWeighting MyDataPileupHistogram.root \
   -useweight true \
   -nrefmax 3 \
   -doNotSave false

