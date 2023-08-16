###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/TABLES/"

###read in text files 
Fcogres <- fread(paste0(dir,"data/COGRES.females_AD_SNPs.txt"))
Mcogres <- fread(paste0(dir,"data/COGRES.males_AD_SNPs.txt"))
Intcogres<- fread(paste0(dir,"data/COGRES.interaction_AD_SNPs.txt"))

Fglobalres <- fread(paste0(dir,"data/GLOBALRES.females_AD_SNPs.txt"))
Mglobalres <- fread(paste0(dir,"data/GLOBALRES.males_AD_SNPs.txt"))
Intglobalres <- fread(paste0(dir,"data/GLOBALRES.interaction_AD_SNPs.txt"))

###select needed cols
Fcogres <- Fcogres[,c("rs_number","beta","se","p-value")]
Mcogres <- Mcogres[,c("rs_number","beta","se","p-value")]
Intcogres <- Intcogres[,c("rs_number","beta","se","p-value")]

Fglobalres <- Fglobalres[,c("rs_number","beta","se","p-value")]
Mglobalres <- Mglobalres[,c("rs_number","beta","se","p-value")]
Intglobalres <- Intglobalres[,c("rs_number","beta","se","p-value")]

###rename
names(Fcogres) <- c("SNP","BETA(females)","SE(females)","P(females)")
names(Mcogres) <- c("SNP","BETA(males)","SE(males)","P(males)")
names(Intcogres) <- c("SNP","BETA(interaction)","SE(interaction)","P(interaction)")

names(Fglobalres) <- c("SNP","BETA(females)","SE(females)","P(females)")
names(Mglobalres) <- c("SNP","BETA(males)","SE(males)","P(males)")
names(Intglobalres) <- c("SNP","BETA(interaction)","SE(interaction)","P(interaction)")

###merge 
cogres <- merge(Fcogres,Mcogres,by="SNP")
cogres <- merge(cogres,Intcogres,by="SNP")
globalres <- merge(Fglobalres,Mglobalres,by="SNP")
globalres <- merge(globalres,Intglobalres,by="SNP")

###read in AD SNPs with gene
AD <- fread(paste0(dir,"AD_SNPs_w_GeneNames.txt"),header=F)
names(AD) <- c("SNP","GENE")

###merge in
cogres <- merge(AD,cogres,by="SNP")
globalres <- merge(AD,globalres,by="SNP")

###order by P value
cogres <- cogres[order(cogres$'P(males)',decreasing=FALSE),]
globalres <- globalres[order(globalres$'P(males)',decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("16_COGRES"=cogres, "17_GLOBALRES"=globalres)
write.xlsx(list_of_datasets,paste0(dir,"excel_docs/Supplementary_Tables_16-17.xlsx"))

