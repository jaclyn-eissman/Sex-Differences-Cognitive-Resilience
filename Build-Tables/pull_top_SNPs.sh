#By Jaclyn Eissman, December 7, 2021

cd /data/h_vmac/eissmajm/Sex_Diff_Final/TABLES
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
for j in males females; do
awk 'NR==1 || $10<0.00001 { print $1, $2, $3, $4, $5, $6, $10 }' ../META/SexStrat/${i}.${j}_2sets.out > ${i}.${j}_2sets_TopSNPs.txt; done; done

for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
awk 'NR==1 || $10<0.00001 { print $1, $2, $3, $4, $5, $6, $10 }' ../META/Interaction/${i}.interaction_2sets.out > ${i}.interaction_2sets_TopSNPs.txt; done
