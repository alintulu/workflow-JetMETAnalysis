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