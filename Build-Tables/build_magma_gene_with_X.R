#By Jaclyn Eissman, December 7, 2021

###Load packages
library(data.table)
library(openxlsx)

###Set directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###Read in text files and pull needed cols
Fcogres <- fread(paste0(dir,"MAGMA/COGRES.females_2sets.genes.out_with_FDR"))
FcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.females_2sets.genes.out_with_FDR"))
Fglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.genes.out_with_FDR"))
FglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.females_2sets.genes.out_with_FDR"))

Mcogres <- fread(paste0(dir,"MAGMA/COGRES.males_2sets.genes.out_with_FDR"))
McogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.males_2sets.genes.out_with_FDR"))
Mglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.genes.out_with_FDR"))
MglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.males_2sets.genes.out_with_FDR"))

Fcogres <- Fcogres[,c("CHR","GENE","ZSTAT","P")]
FcogresNC <- FcogresNC[,c("CHR","GENE","ZSTAT","P")]
Fglobalres <- Fglobalres[,c("CHR","GENE","ZSTAT","P")]
FglobalresNC <- FglobalresNC[,c("CHR","GENE","ZSTAT","P")]

Mcogres <- Mcogres[,c("CHR","GENE","ZSTAT","P")]
McogresNC <- McogresNC[,c("CHR","GENE","ZSTAT","P")]
Mglobalres <- Mglobalres[,c("CHR","GENE","ZSTAT","P")]
MglobalresNC <- MglobalresNC[,c("CHR","GENE","ZSTAT","P")]

###Read in X and pull needed cols
Fcogres_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES.females_2sets.X.genes.out"))
FcogresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES_NC.females_2sets.X.genes.out"))
Fglobalres_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES.females_2sets.X.genes.out"))
FglobalresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES_NC.females_2sets.X.genes.out"))

Mcogres_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES.males_2sets.X.genes.out"))
McogresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/COGRES_NC.males_2sets.X.genes.out"))
Mglobalres_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES.males_2sets.X.genes.out"))
MglobalresNC_X <- fread(paste0(dir,"XCHROM/MAGMA/GLOBALRES_NC.males_2sets.X.genes.out"))

Fcogres_X <- Fcogres_X[,c("CHR","GENE","ZSTAT","P")]
FcogresNC_X <- FcogresNC_X[,c("CHR","GENE","ZSTAT","P")]
Fglobalres_X <- Fglobalres_X[,c("CHR","GENE","ZSTAT","P")]
FglobalresNC_X <- FglobalresNC_X[,c("CHR","GENE","ZSTAT","P")]

Mcogres_X <- Mcogres_X[,c("CHR","GENE","ZSTAT","P")]
McogresNC_X <- McogresNC_X[,c("CHR","GENE","ZSTAT","P")]
Mglobalres_X <- Mglobalres_X[,c("CHR","GENE","ZSTAT","P")]
MglobalresNC_X <- MglobalresNC_X[,c("CHR","GENE","ZSTAT","P")]

###Combine autosome with X
Fcogres <- rbind(Fcogres,Fcogres_X)
FcogresNC <- rbind(FcogresNC,FcogresNC_X)
Fglobalres <- rbind(Fglobalres,Fglobalres_X)
FglobalresNC <- rbind(FglobalresNC,FglobalresNC_X)

Mcogres <- rbind(Mcogres,Mcogres_X)
McogresNC <- rbind(McogresNC,McogresNC_X)
Mglobalres <- rbind(Mglobalres,Mglobalres_X)
MglobalresNC <- rbind(MglobalresNC,MglobalresNC_X)

###Do FDR correction
Fcogres$P.Fdr <- p.adjust(Fcogres$P, method="fdr")
FcogresNC$P.Fdr <- p.adjust(FcogresNC$P, method="fdr")
Fglobalres$P.Fdr <- p.adjust(Fglobalres$P, method="fdr")
FglobalresNC$P.Fdr <- p.adjust(FglobalresNC$P, method="fdr")

Mcogres$P.Fdr <- p.adjust(Mcogres$P, method="fdr")
McogresNC$P.Fdr <- p.adjust(McogresNC$P, method="fdr")
Mglobalres$P.Fdr <- p.adjust(Mglobalres$P, method="fdr")
MglobalresNC$P.Fdr <- p.adjust(MglobalresNC$P, method="fdr")

###Rename cols
names(Fcogres) <- c("CHR","Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(FcogresNC) <- c("CHR","Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(Fglobalres) <- c("CHR","Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(FglobalresNC) <- c("CHR","Gene","Z-stat(females)","P(females)","P.FDR(females)")

names(Mcogres) <- c("CHR","Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(McogresNC) <- c("CHR","Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(Mglobalres) <- c("CHR","Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(MglobalresNC) <- c("CHR","Gene","Z-stat(males)","P(males)","P.FDR(males)")

###Combine
cogres <- merge(Fcogres,Mcogres,by=c("CHR","Gene"))
cogresNC <- merge(FcogresNC,McogresNC,by=c("CHR","Gene"))
globalres <- merge(Fglobalres,Mglobalres,by=c("CHR","Gene"))
globalresNC <- merge(FglobalresNC,MglobalresNC,by=c("CHR","Gene"))

###Order by P-value
cogres <- cogres[order(cogres$`P.FDR(males)`,decreasing=FALSE),]
cogresNC <- cogresNC[order(cogresNC$`P.FDR(males)`,decreasing=FALSE),]
globalres <- globalres[order(globalres$`P.FDR(males)`,decreasing=FALSE),]
globalresNC <- globalresNC[order(globalresNC$`P.FDR(males)`,decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("18_COGRES"=cogres, "19_COGRES_NC"=cogresNC,"20_GLOBALRES"=globalres, "21_GLOBALRES_NC"=globalresNC)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_18-21.xlsx"))


