#!/bin/bash

##Setting up an array of analyses
strat_file_list=$1

##Pathway-level test
magma --gene-results /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/${strat_file_list}.genes.raw --set-annot /data/h_vmac/Programs/magma/custom_pathways.txt --out /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/${strat_file_list}

