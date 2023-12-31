#!/bin/bash
#By Jaclyn Eissman, December 7, 2021

#Set up job array 
pheno_list=$1

#Run GWAS for ACT/ROSMAP cohorts
#males
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ACT_ROSMAP_final --filter-males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/AUTOPSY/SexStrat/ACT_ROSMAP_males_${pheno_list}
    
#females
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ACT_ROSMAP_final --filter-females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/AUTOPSY/SexStrat/ACT_ROSMAP_females_${pheno_list}

#Run GWAS for ADNI/A4 cohorts
#males
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ADNI_A4_final --filter-males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/PET/SexStrat/ADNI_A4_males_${pheno_list}
    
#females
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ADNI_A4_final --filter-females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${pheno_list} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/PET/SexStrat/ADNI_A4_females_${pheno_list}
