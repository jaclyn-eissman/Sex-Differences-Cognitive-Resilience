#By Jaclyn Eissman, December 7, 2021

#Set to fail if there is an error
set -e  

#Create genetic relatedness matrix (GRM), then calculate heritability with restricted maximum likelihood (REML) method

#In everyone
gcta64 --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_final --make-grm --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 1 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 2 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES_NC --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 3 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 4 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES_NC --thread-num 10

#In males only
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_final --filter-males --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_males
gcta64 --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_males --make-grm --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_males --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 1 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES_males --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 2 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES_NC_males --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 3 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES_males --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 4 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES_NC_males --thread-num 10

#In females only
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_final --filter-females --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_females
gcta64 --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_females --make-grm --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_females --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 1 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES_females --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 2 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_COGRES_NC_females --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 3 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES_females --thread-num 10
gcta64 --grm /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --mpheno 4 --reml --out /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/All_datasets_final_all_chrs_herit_GLOBALRES_NC_females --thread-num 10
