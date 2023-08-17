###Load packages
library(data.table)
library(openxlsx)

###Set directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###Read in male files
Mcogres <- fread(paste0(dir,"TABLES/data/COGRES.males_2sets_TopSNPs.txt"))
McogresNC <- fread(paste0(dir,"TABLES/data/COGRES_NC.males_2sets_TopSNPs.txt"))
Mglobalres <- fread(paste0(dir,"TABLES/data/GLOBALRES.males_2sets_TopSNPs.txt"))
MglobalresNC <- fread(paste0(dir,"TABLES/data/GLOBALRES_NC.males_2sets_TopSNPs.txt"))

###Read in XChr male files
McogresNC_X <- fread(paste0(dir,"XCHROM/META/COGRES_NC.males_2sets.X_TopSNPs.txt"))
MglobalresNC_X <- fread(paste0(dir,"XCHROM/META/GLOBALRES_NC.males_2sets.X_TopSNPs.txt"))

###Combine
McogresNC <- rbind(McogresNC,McogresNC_X)
MglobalresNC <- rbind(MglobalresNC,MglobalresNC_X)

###Select needed cols
Mcogres <- Mcogres[,c("rs_number","eaf","beta","se","p-value")]
McogresNC <- McogresNC[,c("rs_number","eaf","beta","se","p-value")]
Mglobalres <- Mglobalres[,c("rs_number","eaf","beta","se","p-value")]
MglobalresNC <- MglobalresNC[,c("rs_number","eaf","beta","se","p-value")]

###Rename
names(Mcogres) <- c("SNP","MAF(males)","BETA(males)","SE(males)","P(males)")
names(McogresNC) <- c("SNP","MAF(males)","BETA(males)","SE(males)","P(males)")
names(Mglobalres) <- c("SNP","MAF(males)","BETA(males)","SE(males)","P(males)")
names(MglobalresNC) <- c("SNP","MAF(males)","BETA(males)","SE(males)","P(males)")

###Order by P-value
Mcogres <- Mcogres[order(Mcogres$'P(males)',decreasing=FALSE),]
McogresNC <- McogresNC[order(McogresNC$'P(males)',decreasing=FALSE),]
Mglobalres <- Mglobalres[order(Mglobalres$'P(males)',decreasing=FALSE),]
MglobalresNC <- MglobalresNC[order(MglobalresNC$'P(males)',decreasing=FALSE),]

###Write out to excel sheets
list_of_datasets <- list("1_COGRES"=Mcogres,"2_COGRES_NC"=McogresNC,"3_GLOBALRES"=Mglobalres,"4_GLOBALRES_NC"=MglobalresNC)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_1-4.xlsx")
