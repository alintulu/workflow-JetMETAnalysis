#!/bin/sh

WorkDir=$1
Files=$2
CodeDir=$3

hadd -k -f Merged.root $Files

jet_draw_closure_x \
   -doPt true \
   -doEta true \
   -path $WorkDir \
   -filename Merged \
   -histMet median \
   -outputDir $WorkDir \
   -draw_guidelines true \
   -doRatioPt false \
   -doRatioEta false


