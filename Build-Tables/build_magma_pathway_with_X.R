###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###read in text files and pull needed cols
Fcogres <- fread(paste0(dir,"MAGMA/COGRES.females_2sets.gsa.out_with_FDR"))
FcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.females_2sets.gsa.out_with_FDR"))
Fglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.gsa.out_with_FDR"))
FglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.females_2sets.gsa.out_with_FDR"))

Mcogres <- fread(paste0(dir,"MAGMA/COGRES.males_2sets.gsa.out_with_FDR"))
McogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.males_2sets.gsa.out_with_FDR"))
Mglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.gsa.out_with_FDR"))
MglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.males_2sets.gsa.out_with_FDR"))

Fcogres <- Fcogres[,c("FULL_NAME","BETA","SE","P")]
FcogresNC <- FcogresNC[,c("FULL_NAME","BETA","SE","P")]
Fglobalres <- Fglobalres[,c("FULL_NAME","BETA","SE","P")]
FglobalresNC <- FglobalresNC[,c("FULL_NAME","BETA","SE","P")]

Mcogres <- Mcogres[,c("FULL_NAME","BETA","SE","P")]
McogresNC <- McogresNC[,c("FULL_NAME","BETA","SE","P")]
Mglobalres <- Mglobalres[,c("FULL_NAME","BETA","SE","P")]
MglobalresNC <- MglobalresNC[,c("FULL_NAME","BETA","SE","P")]

###read in X and pull needed cols
Fcogres_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES.females_2sets.X.path.gsa.out"),skip=4)
FcogresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES_NC.females_2sets.X.path.gsa.out"),skip=4)
Fglobalres_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES.females_2sets.X.path.gsa.out"),skip=4)
FglobalresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES_NC.females_2sets.X.path.gsa.out"),skip=4)

Mcogres_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES.males_2sets.X.path.gsa.out"),skip=4)
McogresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES_NC.males_2sets.X.path.gsa.out"),skip=4)
Mglobalres_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES.males_2sets.X.path.gsa.out"),skip=4)
MglobalresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES_NC.males_2sets.X.path.gsa.out"),skip=4)

Fcogres_X <- Fcogres_X[,c("FULL_NAME","BETA","SE","P")]
FcogresNC_X <- FcogresNC_X[,c("FULL_NAME","BETA","SE","P")]
Fglobalres_X <- Fglobalres_X[,c("FULL_NAME","BETA","SE","P")]
FglobalresNC_X <- FglobalresNC_X[,c("FULL_NAME","BETA","SE","P")]

Mcogres_X <- Mcogres_X[,c("FULL_NAME","BETA","SE","P")]
McogresNC_X <- McogresNC_X[,c("FULL_NAME","BETA","SE","P")]
Mglobalres_X <- Mglobalres_X[,c("FULL_NAME","BETA","SE","P")]
MglobalresNC_X <- MglobalresNC_X[,c("FULL_NAME","BETA","SE","P")]

###combine autosome with X
Fcogres <- rbind(Fcogres,Fcogres_X)
FcogresNC <- rbind(FcogresNC,FcogresNC_X)
Fglobalres <- rbind(Fglobalres,Fglobalres_X)
FglobalresNC <- rbind(FglobalresNC,FglobalresNC_X)

Mcogres <- rbind(Mcogres,Mcogres_X)
McogresNC <- rbind(McogresNC,McogresNC_X)
Mglobalres <- rbind(Mglobalres,Mglobalres_X)
MglobalresNC <- rbind(MglobalresNC,MglobalresNC_X)

###do FDR correction
Fcogres$P.Fdr <- p.adjust(Fcogres$P, method="fdr")
FcogresNC$P.Fdr <- p.adjust(FcogresNC$P, method="fdr")
Fglobalres$P.Fdr <- p.adjust(Fglobalres$P, method="fdr")
FglobalresNC$P.Fdr <- p.adjust(FglobalresNC$P, method="fdr")

Mcogres$P.Fdr <- p.adjust(Mcogres$P, method="fdr")
McogresNC$P.Fdr <- p.adjust(McogresNC$P, method="fdr")
Mglobalres$P.Fdr <- p.adjust(Mglobalres$P, method="fdr")
MglobalresNC$P.Fdr <- p.adjust(MglobalresNC$P, method="fdr")

###rename
names(Fcogres) <- c("Pathway","Beta(females)","SE(females)","P(females)","P.FDR(females)")
names(FcogresNC) <- c("Pathway","Beta(females)","SE(females)","P(females)","P.FDR(females)")
names(Fglobalres) <- c("Pathway","Beta(females)","SE(females)","P(females)","P.FDR(females)")
names(FglobalresNC) <- c("Pathway","Beta(females)","SE(females)","P(females)","P.FDR(females)")

names(Mcogres) <- c("Pathway","Beta(males)","SE(males)","P(males)","P.FDR(males)")
names(McogresNC) <- c("Pathway","Beta(males)","SE(males)","P(males)","P.FDR(males)")
names(Mglobalres) <- c("Pathway","Beta(males)","SE(males)","P(males)","P.FDR(males)")
names(MglobalresNC) <- c("Pathway","Beta(males)","SE(males)","P(males)","P.FDR(males)")

###combine
cogres <- merge(Fcogres,Mcogres,by="Pathway")
cogresNC <- merge(FcogresNC,McogresNC,by="Pathway")
globalres <- merge(Fglobalres,Mglobalres,by="Pathway")
globalresNC <- merge(FglobalresNC,MglobalresNC,by="Pathway")

###order by P value
cogres <- cogres[order(cogres$`P.FDR(males)`,decreasing=FALSE),]
cogresNC <- cogresNC[order(cogresNC$`P.FDR(males)`,decreasing=FALSE),]
globalres <- globalres[order(globalres$`P.FDR(males)`,decreasing=FALSE),]
globalresNC <- globalresNC[order(globalresNC$`P.FDR(males)`,decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("22_COGRES"=cogres,"23_COGRES_NC"=cogresNC,"24_GLOBALRES"=globalres,"25_GLOBALRES_NC"=globalresNC)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_22-25.xlsx"))




