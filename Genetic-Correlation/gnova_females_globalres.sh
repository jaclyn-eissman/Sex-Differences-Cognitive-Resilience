#!/bin/bash

#Load correct modules and source virtual environment
module restore gnova_python2
source /data/h_vmac/eissmajm/python2/bin/activate

#Set up array of summary stats
trait_list=$1

#####Sets up a GNOVA job array for all traits 
/data/h_vmac/eissmajm/GNOVA-2.0/gnova.py /data/h_vmac/eissmajm/SUMSTATS/Munged_Traits/${trait_list}.sumstats.gz /data/h_vmac/eissmajm//Sex_Diff_Final/GNOVA/SexStrat/females/GLOBALRES.females_2sets.sumstats.gz --bfile /data/h_vmac/eissmajm/GNOVA-2.0/genotype_1KG_eur_SNPmaf5/eur_chr@_SNPmaf5 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/SexStrat/females/globalres/${trait_list}.females.globalres.txt 
