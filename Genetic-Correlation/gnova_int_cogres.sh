#!/bin/bash
#By Jaclyn Eissman, December 7, 2021

#Load module collection and source Python virtual environment
module restore gnova_python2
source /data/h_vmac/eissmajm/python2/bin/activate

#Set up job array
trait_list=$1

#####Runs genetic correlation analysis
/data/h_vmac/eissmajm/GNOVA-2.0/gnova.py /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/${trait_list}.sumstats.gz /data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/Interaction/COGRES.interaction_2sets.sumstats.gz --bfile /data/h_vmac/eissmajm/GNOVA-2.0/genotype_1KG_eur_SNPmaf5/eur_chr@_SNPmaf5 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/Interaction/cogres/${trait_list}.int.cogres.txt 
