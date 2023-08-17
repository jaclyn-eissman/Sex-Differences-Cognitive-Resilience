#By Jaclyn Eissman, December 7, 2021

###Load packages
library(data.table)
library(openxlsx)

###Set directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###Read in text files 
Fcogres <- read.table(paste0(dir,"GNOVA/females/females.cogres.combined.txt"),header=F)
FcogresNC <- read.table(paste0(dir,"GNOVA/females/females.cogresNC.combined.txt"),header=F)
Fglobalres <- read.table(paste0(dir,"GNOVA/females/females.globalres.combined.txt"),header=F)
FglobalresNC <- read.table(paste0(dir,"GNOVA/females/females.globalresNC.combined.txt"),header=F)

Mcogres <- read.table(paste0(dir,"GNOVA/males/males.cogres.combined.txt"),header=F)
McogresNC <- read.table(paste0(dir,"GNOVA/males/males.cogresNC.combined.txt"),header=F)
Mglobalres <- read.table(paste0(dir,"GNOVA/males/males.globalres.combined.txt"),header=F)
MglobalresNC <- read.table(paste0(dir,"GNOVA/males/males.globalresNC.combined.txt"),header=F)

###Pull needed cols
Fcogres  <- Fcogres[,c("V17","V3","V4","V6")]
names(Fcogres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
FcogresNC  <- FcogresNC[,c("V17","V3","V4","V6")]
names(FcogresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
Fglobalres <- Fglobalres[,c("V17","V3","V4","V6")]
names(Fglobalres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
FglobalresNC  <- FglobalresNC[,c("V17","V3","V4","V6")]
names(FglobalresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")

Mcogres  <- Mcogres[,c("V17","V3","V4","V6")]
names(Mcogres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
McogresNC  <- McogresNC[,c("V17","V3","V4","V6")]
names(McogresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
Mglobalres <- Mglobalres[,c("V17","V3","V4","V6")]
names(Mglobalres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
MglobalresNC  <- MglobalresNC[,c("V17","V3","V4","V6")]
names(MglobalresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")

###Order by P-value
Fcogres <- Fcogres[order(Fcogres$pvalue_corrected,decreasing=FALSE),]
FcogresNC <- FcogresNC[order(FcogresNC$pvalue_corrected,decreasing=FALSE),]
Fglobalres <- Fglobalres[order(Fglobalres$pvalue_corrected,decreasing=FALSE),]
FglobalresNC <- FglobalresNC[order(FglobalresNC$pvalue_corrected,decreasing=FALSE),]

Mcogres <- Mcogres[order(Mcogres$pvalue_corrected,decreasing=FALSE),]
McogresNC <- McogresNC[order(McogresNC$pvalue_corrected,decreasing=FALSE),]
Mglobalres <- Mglobalres[order(Mglobalres$pvalue_corrected,decreasing=FALSE),]
MglobalresNC <- MglobalresNC[order(MglobalresNC$pvalue_corrected,decreasing=FALSE),]

###Do an FDR correction
Fcogres$P.Fdr <- p.adjust(Fcogres$pvalue_corrected, method="fdr")
FcogresNC$P.Fdr <- p.adjust(FcogresNC$pvalue_corrected, method="fdr")
Fglobalres$P.Fdr <- p.adjust(Fglobalres$pvalue_corrected, method="fdr")
FglobalresNC$P.Fdr <- p.adjust(FglobalresNC$pvalue_corrected, method="fdr")

Mcogres$P.Fdr <- p.adjust(Mcogres$pvalue_corrected, method="fdr")
McogresNC$P.Fdr <- p.adjust(McogresNC$pvalue_corrected, method="fdr")
Mglobalres$P.Fdr <- p.adjust(Mglobalres$pvalue_corrected, method="fdr")
MglobalresNC$P.Fdr <- p.adjust(MglobalresNC$pvalue_corrected, method="fdr")

###Rename cols
names(Fcogres) <- c("Trait","Rho(females)","SE(females)","P(females)","P.FDR(females)")
names(FcogresNC) <- c("Trait","Rho(females)","SE(females)","P(females)","P.FDR(females)")
names(Fglobalres) <- c("Trait","Rho(females)","SE(females)","P(females)","P.FDR(females)")
names(FglobalresNC) <- c("Trait","Rho(females)","SE(females)","P(females)","P.FDR(females)")

names(Mcogres) <- c("Trait","Rho(males)","SE(males)","P(males)","P.FDR(males)")
names(McogresNC) <- c("Trait","Rho(males)","SE(males)","P(males)","P.FDR(males)")
names(Mglobalres) <- c("Trait","Rho(males)","SE(males)","P(males)","P.FDR(males)")
names(MglobalresNC) <- c("Trait","Rho(males)","SE(males)","P(males)","P.FDR(males)")

###Combine
cogres <- merge(Fcogres,Mcogres,by="Trait")
cogresNC <- merge(FcogresNC,McogresNC,by="Trait")
globalres <- merge(Fglobalres,Mglobalres,by="Trait")
globalresNC <- merge(FglobalresNC,MglobalresNC,by="Trait")

###Order by male p.fdr
cogres <- cogres[order(cogres$`P.FDR(males)`,decreasing=FALSE),]
cogresNC <- cogresNC[order(cogresNC$`P.FDR(males)`,decreasing=FALSE),]
globalres <- globalres[order(globalres$`P.FDR(males)`,decreasing=FALSE),]
globalresNC <- globalresNC[order(globalresNC$`P.FDR(males)`,decreasing=FALSE),]

###Write out to excel sheets
list_of_datasets <- list("26_COGRES"=cogres,"27_COGRES_NC"=cogresNC,"28_GLOBALRES"=globalres,"29_GLOBALRES_NC"=globalresNC)
write.xlsx(list_of_datasets,paste0(dir,"TABLES/excel_docs/Supplementary_Tables_26-29.xlsx"))

