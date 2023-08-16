#packages
library(data.table)
library(openxlsx)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in files
ci <- fread(paste0(dir,"FUMA/SNP2gene/ci.txt"))
ciProm <- fread(paste0(dir,"FUMA/SNP2gene/ciProm.txt"))

#pull needed cols
ci <- ci[,c("SNPs","genes","tissue/cell","type","FDR")]
names(ci) <- c("SNPs","Genes","Tissue/Cell","Data_Type","P.FDR")

ciProm <- ciProm[,c("genes","reg_region","tissue/cell","type")]
names(ciProm) <- c("Genes","Regulatory_Region","Tissue/Cell","Data_Type")

#write out
list_of_datasets <- list("14_ChromatinInt"=ci, "15_CI_Promoter"=ciProm)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_14-15.xlsx"))

#pull subset for paper
ci_subset <- ci[grepl("ENSG00000107485|ENSG00000165632|ENSG00000151657",ci$Genes),]
ciProm_subset <- ciProm[grepl("ENSG00000107485|ENSG00000165632|ENSG00000151657",ciProm$Genes),]

#write out
write.table(ci_subset,paste0(dir,"FUMA/ci_subset_females_GLOBALRES_NC.txt"),quote=F,row.names=F,col.names=T)
write.table(ciProm_subset,paste0(dir,"FUMA/ciProm_subset_females_GLOBALRES_NC.txt"),quote=F,row.names=F,col.names=T)
