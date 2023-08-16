cd /data/h_vmac/eissmajm/Sex_Diff_Final/TABLES
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC;
do
for j in males females;
do
grep -wFf AD_SNPs.txt ../META/SexStrat/${i}.${j}_2sets.out > ${i}.${j}_AD_SNPs.txt
awk ' { print $1, $2, $3, $4, $5, $6, $10 }' ${i}.${j}_AD_SNPs.txt > tmp && mv tmp ${i}.${j}_AD_SNPs.txt
sed  -i '1i rs_number reference_allele other_allele eaf beta se p-value' ${i}.${j}_AD_SNPs.txt
done
done

for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC;
do
grep -wFf AD_SNPs.txt ../META/Interaction/${i}.interaction_2sets.out > ${i}.interaction_AD_SNPs.txt
awk ' { print $1, $2, $3, $4, $5, $6, $10 }' ${i}.interaction_AD_SNPs.txt > tmp && mv tmp ${i}.interaction_AD_SNPs.txt
sed  -i '1i rs_number reference_allele other_allele eaf beta se p-value' ${i}.interaction_AD_SNPs.txt
done
