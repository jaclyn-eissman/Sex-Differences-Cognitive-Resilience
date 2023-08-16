#set to fail if error
set -e 

#run gene test
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
for j in males females; do
magma --bfile /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/DATA/All_datasets_final_X --pval /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/META/${i}.${j}_2sets.X.out use=rs_number,p-value ncol=n_samples --gene-annot /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/MAGMA/All_datasets_final_X.genes.annot --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/MAGMA/${i}.${j}_2sets.X
done
done

#run pathway test
for i in COGRES COGRES_NC GLOBALRES GLOBALRES_NC; do
for j in males females; do
magma --gene-results /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/MAGMA/${i}.${j}_2sets.X.genes.raw --set-annot /data/h_vmac/Programs/magma/custom_pathways.txt --out /data/h_vmac/eissmajm/Sex_Diff_Final/XCHROM/MAGMA/${i}.${j}_2sets.X.path
done
done
