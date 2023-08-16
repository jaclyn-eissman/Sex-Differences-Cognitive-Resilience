#set to error out if fail
set -e 

#run gwas
for i in ACT_ROSMAP ADNI_A4; do
for j in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
plink --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/${i}_X_final --filter-males --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${j} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/XWAS/${i}_${j}_X_males --memory 15000
plink --bfile /data/h_vmac//eissmajm/Sex_Diff_Final/XCHROM/DATA/${i}_X_final --filter-females --pheno /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt --pheno-name ${j} --covar /data/h_vmac/eissmajm/Sex_Diff_Final/DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt --covar-name age, PC1, PC2, PC3 --linear --ci 0.95 --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/XWAS/${i}_${j}_X_females --memory 15000
done
done

#pull snp term
for i in ACT_ROSMAP ADNI_A4; do
for j in $( ls /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/XWAS/${i}_*_X_females.assoc.linear ); do
new_file_name=$( echo $j | sed 's/females/femalesADD/' )
awk 'NR==1 || $5 ~ /ADD/ { print }' $j > $new_file_name
done
done

for i in ACT_ROSMAP ADNI_A4; do
for j in $( ls /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/XWAS/${i}_*_X_males.assoc.linear ); do
new_file_name=$( echo $j | sed 's/males/malesADD/' )
awk 'NR==1 || $5 ~ /ADD/ { print }' $j > $new_file_name
done
done
