#!/bin/bash
#By Jaclyn Eissman, December 7, 2021

#Set up array of summary stats
pheno_list=$1 #leverages text file: pheno_list.txt 

#Run Sex-Interaction GWAS for ACT and ROS/MAP cohorts
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ACT_ROSMAP_final --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, sex, PC1, PC2, PC3 --linear interaction --parameters 1-6, 8 --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/AUTOPSY/Interaction/ACT_ROSMAP_int_${pheno_list}

#Run Sex-Interaction GWAS for ADNI and A4 cohorts
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ADNI_A4_final --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, sex, PC1, PC2, PC3 --linear interaction --parameters 1-6, 8 --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/PET/Interaction/ADNI_A4_int_${pheno_list}

