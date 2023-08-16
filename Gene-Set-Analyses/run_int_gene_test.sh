#!/bin/bash
#By Jaclyn Eissman, December 7, 2021

##Setting up a job array for analysis
int_file_list=$1

##Perform gene-level test
magma --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_final --pval /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/${int_file_list}.out use=rs_number,p-value ncol=n_samples --gene-annot /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/All_datasets_final.genes.annot --out /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/${int_file_list}
