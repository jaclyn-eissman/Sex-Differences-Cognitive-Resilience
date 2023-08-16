#!/bin/bash

##Setting up an array of analyses
strat_file_list=$1

##Gene-level test
magma --bfile  /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_final --pval  /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/${strat_file_list}.out use=rs_number,p-value ncol=n_samples --gene-annot /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/All_datasets_final.genes.annot --out /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/${strat_file_list}
