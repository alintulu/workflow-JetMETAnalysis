#!/bin/sh --login

#BSUB -q 1nh

WorkDir=$1
Files=$2
CodeDir=$3

#hadd -k -f Input.root `echo $Files | tr ':' ' '`

cd $CodeDir

jet_apply_jec_x \
   -input $Files \
   -output $WorkDir/JRA_jecl1.root \
   -jecpath $WorkDir \
   -era ParallelMC \
   -levels 1 \
   -algs ak4pf \
   -L1FastJet true \
   -saveitree false

jet_response_analyzer_x jra.config \
   -input $WorkDir/JRA_jecl1.root \
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