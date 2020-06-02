#!/bin/sh

WorkDir=$1
Files=$2
CodeDir=$3

hadd -k -f Merged.root $Files

jet_l2_correction_x \
   -input Merged.root \
   -algs ak4pfl1 \
   -era ParallelMC \
   -output l2.root \
   -outputDir $WorkDir/ \
   -makeCanvasVariable AbsCorVsJetPt:JetEta \
   -l2l3 true \
   -batch true \
   -histMet median \
   -delphes false \
   -maxFitIter 30 \
   -l2calofit DynamicMin \
   -l2pffit splineAkima \
   -ptclip 20


