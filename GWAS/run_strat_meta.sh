set -e

#copy files
rsync -avh /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/AUTOPSY/SexStrat/*.assoc.linear /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
rsync -avh /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/PET/SexStrat/*.assoc.linear /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/

#pull ADD term, females
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in ACT_ROSMAP ADNI_A4;
do
for j in $( ls ${i}_females_*.assoc.linear );
do 
new_file_name=$( echo $j | sed 's/females/femalesADD/' )
awk 'NR==1 || $5 ~ /ADD/ { print }' $j > $new_file_name
done
done

#pull ADD term, males
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in ACT_ROSMAP ADNI_A4;
do
for j in $( ls ${i}_males_*.assoc.linear );
do
new_file_name=$( echo $j | sed 's/males/malesADD/' )
awk 'NR==1 || $5 ~ /ADD/ { print }' $j > $new_file_name
done
done

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in ACT_ROSMAP ADNI_A4;
do
for j in COGRES GLOBALRES;
do
for k in males females;
do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_${k}ADD_${j}.assoc.linear ../../DATA/${i}_final.frq ${i}_${k}.${j}.GWAMA
done
done
done

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in ACT_ROSMAP ADNI_A4;
do
for j in COGRES_NC GLOBALRES_NC;
do
for k in males females;
do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_${k}ADD_${j}.assoc.linear ../../DATA/${i}_final_CN.frq ${i}_${k}.${j}.GWAMA
done
done
done

#run meta-analyses
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC;
do
for j in males females;
do
printf "ADNI_A4_${j}.${i}.GWAMA
ACT_ROSMAP_${j}.${i}.GWAMA" > ${i}.${j}.in
GWAMA --filelist ${i}.${j}.in --output ${i}.${j} --quantitative --name_marker MARKERNAME
awk '{if (($15 > 1) || (NR==1)) print}' ${i}.${j}.out > ${i}.${j}_2sets.out
Rscript /data/h_vmac/eissmajm/scripts/qq_plot.R ${i}.${j}_2sets.out
done
done

#create miami's
cd /data/h_vmac/eissmajm/Sex_Diff_Final/META/SexStrat/
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC;
do
sh /data/h_vmac/eissmajm/scripts/Generate_Miami_plot_b38.sh ${i}.females_2sets.out FEMALES hotpink1 ${i}.males_2sets.out MALES deepskyblue2 gwama ../../DATA/All_datasets_final_forMiami.txt ${i}
done


