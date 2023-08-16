###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###read in text files 
Fcogres <- fread(paste0(dir,"MAGMA/COGRES.females_2sets.genes.out_with_FDR"))
FcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.females_2sets.genes.out_with_FDR"))
Fglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.genes.out_with_FDR"))
FglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.females_2sets.genes.out_with_FDR"))

Mcogres <- fread(paste0(dir,"MAGMA/COGRES.males_2sets.genes.out_with_FDR"))
McogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.males_2sets.genes.out_with_FDR"))
Mglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.genes.out_with_FDR"))
MglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.males_2sets.genes.out_with_FDR"))

###pull needed cols
Fcogres <- Fcogres[,c("GENE","ZSTAT","P","P.fdr")]
FcogresNC <- FcogresNC[,c("GENE","ZSTAT","P","P.fdr")]
Fglobalres <- Fglobalres[,c("GENE","ZSTAT","P","P.fdr")]
FglobalresNC <- FglobalresNC[,c("GENE","ZSTAT","P","P.fdr")]

Mcogres <- Mcogres[,c("GENE","ZSTAT","P","P.fdr")]
McogresNC <- McogresNC[,c("GENE","ZSTAT","P","P.fdr")]
Mglobalres <- Mglobalres[,c("GENE","ZSTAT","P","P.fdr")]
MglobalresNC <- MglobalresNC[,c("GENE","ZSTAT","P","P.fdr")]

###rename
names(Fcogres) <- c("Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(FcogresNC) <- c("Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(Fglobalres) <- c("Gene","Z-stat(females)","P(females)","P.FDR(females)")
names(FglobalresNC) <- c("Gene","Z-stat(females)","P(females)","P.FDR(females)")

names(Mcogres) <- c("Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(McogresNC) <- c("Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(Mglobalres) <- c("Gene","Z-stat(males)","P(males)","P.FDR(males)")
names(MglobalresNC) <- c("Gene","Z-stat(males)","P(males)","P.FDR(males)")

###combine
cogres <- merge(Fcogres,Mcogres,by="Gene")
cogresNC <- merge(FcogresNC,McogresNC,by="Gene")
globalres <- merge(Fglobalres,Mglobalres,by="Gene")
globalresNC <- merge(FglobalresNC,MglobalresNC,by="Gene")

###order by P value
cogres <- cogres[order(cogres$`P.FDR(males)`,decreasing=FALSE),]
cogresNC <- cogresNC[order(cogresNC$`P.FDR(males)`,decreasing=FALSE),]
globalres <- globalres[order(globalres$`P.FDR(males)`,decreasing=FALSE),]
globalresNC <- globalresNC[order(globalresNC$`P.FDR(males)`,decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("Residual Cog. Resilience"=cogres, "Residual Cog. Resilience (CN)"=cogresNC,
                         "Combined Resilience"=globalres, "Combined Resilience (CN)"=globalresNC)
write.xlsx(list_of_datasets,paste0(dir,"excel_docs/MAGMA_genes_all.xlsx"))

###read in text files 
Fcogres <- fread(paste0(dir,"MAGMA/COGRES.females_2sets.gsa.out_with_FDR"))
FcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.females_2sets.gsa.out_with_FDR"))
Fglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.gsa.out_with_FDR"))
FglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.females_2sets.gsa.out_with_FDR"))

Mcogres <- fread(paste0(dir,"MAGMA/COGRES.males_2sets.gsa.out_with_FDR"))
McogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.males_2sets.gsa.out_with_FDR"))
Mglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.gsa.out_with_FDR"))
MglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.males_2sets.gsa.out_with_FDR"))

###pull needed cols
Fcogres <- Fcogres[,c("FULL_NAME","BETA","SE","P","P.fdr")]
FcogresNC <- FcogresNC[,c("FULL_NAME","BETA","SE","P","P.fdr")]
Fglobalres <- Fglobalres[,c("FULL_NAME","BETA","SE","P","P.fdr")]
FglobalresNC <- FglobalresNC[,c("FULL_NAME","BETA","SE","P","P.fdr")]

Mcogres <- Mcogres[,c("FULL_NAME","BETA","SE","P","P.fdr")]
McogresNC <- McogresNC[,c("FULL_NAME","BETA","SE","P","P.fdr")]
Mglobalres <- Mglobalres[,c("FULL_NAME","BETA","SE","P","P.fdr")]
MglobalresNC <- MglobalresNC[,c("FULL_NAME","BETA","SE","P","P.fdr")]

###rename
names(Fcogres) <- c("Pathway","Beta(females)","SE(females)","P(females)","P.FDR(females)")
names(FcogresNC) <- c("Pathway","Beta(females)","P(females)","SE(females)","P.FDR(females)")
names(Fglobalres) <- c("Pathway","Beta(females)","P(females)","SE(females)","P.FDR(females)")
names(FglobalresNC) <- c("Pathway","Beta(females)","P(females)","SE(females)","P.FDR(females)")

names(Mcogres) <- c("Pathway","Beta(males)","P(males)","SE(males)","P.FDR(males)")
names(McogresNC) <- c("Pathway","Beta(males)","P(males)","SE(males)","P.FDR(males)")
names(Mglobalres) <- c("Pathway","Beta(males)","P(males)","SE(males)","P.FDR(males)")
names(MglobalresNC) <- c("Pathway","Beta(males)","P(males)","SE(males)","P.FDR(males)")

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
list_of_datasets <- list("Residual Cog. Resilience"=cogres, "Residual Cog. Resilience (CN)"=cogresNC,
                         "Combined Resilience"=globalres, "Combined Resilience (CN)"=globalresNC)
write.xlsx(list_of_datasets,paste0(dir,"excel_docs/MAGMA_pathways_all.xlsx"))
