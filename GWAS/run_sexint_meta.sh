set -e

#copy files
rsync -avh /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/AUTOPSY/Interaction/*.assoc.linear /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/
rsync -avh /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/PET/Interaction/*.assoc.linear /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/

#pull ADD*sex term only
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/
for i in ACT_ROSMAP ADNI_A4;
do
for j in $( ls ${i}_int_*.assoc.linear );
do
new_file_name=$( echo $j | sed 's/int/intonly/' )
awk 'NR==1 || $5 ~ /ADDx/ { print }' $j > $new_file_name
done
done

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/
for i in ACT_ROSMAP ADNI_A4;
do
for j in COGRES GLOBALRES;
do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_intonly_${j}.assoc.linear ../../DATA/${i}_final.frq ${i}_intonly.${j}.GWAMA
done
done

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/
for i in ACT_ROSMAP ADNI_A4;
do
for j in COGRES_NC GLOBALRES_NC;
do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_intonly_${j}.assoc.linear ../../DATA/${i}_final_CN.frq ${i}_intonly.${j}.GWAMA
done
done

#run meta-analyses and create plots
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/Interaction/
for i in COGRES GLOBALRES COGRES_NC GLOBALRES_NC;
do
printf "ADNI_A4_intonly.${i}.GWAMA
ACT_ROSMAP_intonly.${i}.GWAMA" > ${i}.interaction.in
GWAMA --filelist ${i}.interaction.in --output ${i}.interaction --quantitative --name_marker MARKERNAME
awk '{if (($15 > 1) || (NR==1)) print}' ${i}.interaction.out > ${i}.interaction_2sets.out
Rscript /data/h_vmac/eissmajm/scripts/man_qq_plots_noNA.R ${i}.interaction_2sets.out ../../DATA/All_datasets_final.bim
done
