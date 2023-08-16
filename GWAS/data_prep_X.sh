#set to error out if fails
set -e

#add dataset label to IDs
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final --update-ids /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/A4_ids_to_update.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final_IDs --memory 15000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_matchIDs --update-ids /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ACT_ids_to_update.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_IDs --memory 15000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final --update-ids /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ADNI_ids_to_update.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final_IDs --memory 15000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final --update-ids /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ROSMAP_ids_to_update.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final_IDs --memory 15000

#A1/MAF check
Rscript /data/h_vmac/eissmajm/github_repos/GWAS_QC/pre_merge_A1_MAF_check.R PET /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final_IDs.frq /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final_IDs.frq
Rscript /data/h_vmac/eissmajm/github_repos/GWAS_QC/pre_merge_A1_MAF_check.R AUTOPSY /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_IDs.frq /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final_IDs.frq

plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final_IDs --extract /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/PET_A1_MAF_matches.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final_IDs_keep --memory 12000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final_IDs --extract /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/PET_A1_MAF_matches.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final_IDs_keep --memory 12000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_IDs --extract /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/AUTOPSY_A1_MAF_matches.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_IDs_keep  --memory 12000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final_IDs --extract /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/AUTOPSY_A1_MAF_matches.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final_IDs_keep --memory 12000

#merge datasets
printf "/data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_X_NHW_imputed_final_IDs_keep
/data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ROSMAP_X_NHW_imputed_final_IDs_keep" > /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/AUTOSPY_X_list.txt
plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/AUTOSPY_X_list.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_ROSMAP --memory 15000

printf "/data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/A4_X_NHW_imputed_final_IDs_keep
/data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_X_NHW_imputed_final_IDs_keep" > /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/PET_X_list.txt
plink --merge-list /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/PET_X_list.txt --make-bed --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_A4 --memory 15000

#remove relateds and PC outliers
awk '{ print $1, $2 }' /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ACT_ROSMAP_final.fam > /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_ROSMAP_ids_keep.txt
awk '{ print $1, $2 }' /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/ADNI_A4_final.fam > /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_A4_ids_keep.txt

plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_ROSMAP --keep /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_ROSMAP_ids_keep.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ACT_ROSMAP_X_final --memory 15000
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_A4 --keep /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_A4_ids_keep.txt --make-bed --freq --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/ADNI_A4_X_final --memory 15000


