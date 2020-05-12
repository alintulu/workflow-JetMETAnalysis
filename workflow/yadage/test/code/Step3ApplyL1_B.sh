#!/bin/sh --login

#BSUB -q 1nh

WorkDir=$1
Files=$2
CodeDir=$3

#hadd -k -f Input.root `echo $Files | tr ':' ' '`

jet_response_analyzer_x jra.config \
   -input $Files \
   -nbinsabsrsp 0 \
   -nbinsetarsp 0 \
   -nbinsphirsp 0 \
   -nbinsrelrsp 200 \
   -doflavor false \
   -flavorDefinition phys \
   -MCPUReWeighting $WorkDir/MyMCPileupHistogram.root \
   -MCPUHistoName pileup \
   -DataPUReWeighting $WorkDir/MyDataPileupHistogram.root \
   -DataPUHistoName pileup \
   -output $WorkDir/jra_jecl1.root \
   -useweight true \
   -nrefmax 3 \
   -algs ak4pfl1:0.2 \
   -relrspmin 0.0 \
   -relrspmax 2.0