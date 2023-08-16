###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###read in female files
Fcogres <- fread(paste0(dir,"TABLES/data/COGRES.females_2sets_TopSNPs.txt"))
FcogresNC <- fread(paste0(dir,"TABLES/data/COGRES_NC.females_2sets_TopSNPs.txt"))
Fglobalres <- fread(paste0(dir,"TABLES/data/GLOBALRES.females_2sets_TopSNPs.txt"))
FglobalresNC <- fread(paste0(dir,"TABLES/data/GLOBALRES_NC.females_2sets_TopSNPs.txt"))

###read in XChr femmale files
Fglobalres_X <- fread(paste0(dir,"XCHROM/META/GLOBALRES.females_2sets.X_TopSNPs.txt"))
FglobalresNC_X <- fread(paste0(dir,"XCHROM/META/GLOBALRES_NC.females_2sets.X_TopSNPs.txt"))

###combine
Fglobalres <- rbind(Fglobalres,Fglobalres_X)
FglobalresNC <- rbind(FglobalresNC,FglobalresNC_X)

###select needed cols
Fcogres <- Fcogres[,c("rs_number","eaf","beta","se","p-value")]
FcogresNC <- FcogresNC[,c("rs_number","eaf","beta","se","p-value")]
Fglobalres <- Fglobalres[,c("rs_number","eaf","beta","se","p-value")]
FglobalresNC <- FglobalresNC[,c("rs_number","eaf","beta","se","p-value")]

###rename
names(Fcogres) <- c("SNP","MAF(females)","BETA(females)","SE(females)","P(females)")
names(FcogresNC) <- c("SNP","MAF(females)","BETA(females)","SE(females)","P(females)")
names(Fglobalres) <- c("SNP","MAF(females)","BETA(females)","SE(females)","P(females)")
names(FglobalresNC) <- c("SNP","MAF(females)","BETA(females)","SE(females)","P(females)")

###order by P value
Fcogres <- Fcogres[order(Fcogres$'P(females)',decreasing=FALSE),]
FcogresNC <- FcogresNC[order(FcogresNC$'P(females)',decreasing=FALSE),]
Fglobalres <- Fglobalres[order(Fglobalres$'P(females)',decreasing=FALSE),]
FglobalresNC <- FglobalresNC[order(FglobalresNC$'P(females)',decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("5_COGRES"=Fcogres,"6_COGRES_NC"=FcogresNC,"7_GLOBALRES"=Fglobalres,"8_GLOBALRES_NC"=FglobalresNC)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_5-8.xlsx"))

