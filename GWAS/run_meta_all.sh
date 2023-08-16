#set to fail if error
set -e 

#copy XWAS files
rsync -avh /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/XWAS/*ADD.assoc.linear /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/META/

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/META
for i in ACT_ROSMAP ADNI_A4; do
for j in COGRES GLOBALRES; do
for k in males females; do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_${j}_X_${k}ADD.assoc.linear ../DATA/${i}_X_final.frq ${i}_${k}.${j}.GWAMA
done
done
done

#create GWAMA files
cd /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/META
for i in ACT_ROSMAP ADNI_A4; do
for j in COGRES_NC GLOBALRES_NC; do
for k in males females; do
perl /data/h_vmac/eissmajm/scripts/plink2GWAMA_modified.pl ${i}_${j}_X_${k}ADD.assoc.linear ../DATA/${i}_X_final_CN.frq ${i}_${k}.${j}.GWAMA
done
done
done

#run meta-analyses
cd /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/META
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
for j in males females; do
printf "ADNI_A4_${j}.${i}.GWAMA
ACT_ROSMAP_${j}.${i}.GWAMA" > ${i}.${j}.X.in
GWAMA --filelist ${i}.${j}.X.in --output ${i}.${j}.X --quantitative --name_marker MARKERNAME
awk '{if (($15 > 1) || (NR==1)) print}' ${i}.${j}.X.out > ${i}.${j}_2sets.X.out
done
done
