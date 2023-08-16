###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###read in text files 
Fcogres <- read.table(paste0(dir,"GNOVA/females/females.cogres.combined.txt"),header=F)
FcogresNC <- read.table(paste0(dir,"GNOVA/females/females.cogresNC.combined.txt"),header=F)
Fglobalres <- read.table(paste0(dir,"GNOVA/females/females.globalres.combined.txt"),header=F)
FglobalresNC <- read.table(paste0(dir,"GNOVA/females/females.globalresNC.combined.txt"),header=F)

Mcogres <- read.table(paste0(dir,"GNOVA/males/males.cogres.combined.txt"),header=F)
McogresNC <- read.table(paste0(dir,"GNOVA/males/males.cogresNC.combined.txt"),header=F)
Mglobalres <- read.table(paste0(dir,"GNOVA/males/males.globalres.combined.txt"),header=F)
MglobalresNC <- read.table(paste0(dir,"GNOVA/males/males.globalresNC.combined.txt"),header=F)

Intcogres <- read.table(paste0(dir,"GNOVA/Interaction/Interaction.cogres.combined.txt"),header=F)
IntcogresNC <- read.table(paste0(dir,"GNOVA/Interaction/Interaction.cogresNC.combined.txt"),header=F)
Intglobalres <- read.table(paste0(dir,"GNOVA/Interaction/Interaction.globalres.combined.txt"),header=F)
IntglobalresNC <- read.table(paste0(dir,"GNOVA/Interaction/Interaction.globalresNC.combined.txt"),header=F)

###pull needed cols
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

Intcogres  <- Intcogres[,c("V17","V3","V4","V6")]
names(Intcogres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
IntcogresNC  <- IntcogresNC[,c("V17","V3","V4","V6")]
names(IntcogresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
Intglobalres <- Intglobalres[,c("V17","V3","V4","V6")]
names(Intglobalres) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
IntglobalresNC  <- IntglobalresNC[,c("V17","V3","V4","V6")]
names(IntglobalresNC) <- c("trait","rho_corrected","se_rho","pvalue_corrected")

###order by Pvalue
Fcogres <- Fcogres[order(Fcogres$pvalue_corrected,decreasing=FALSE),]
FcogresNC <- FcogresNC[order(FcogresNC$pvalue_corrected,decreasing=FALSE),]
Fglobalres <- Fglobalres[order(Fglobalres$pvalue_corrected,decreasing=FALSE),]
FglobalresNC <- FglobalresNC[order(FglobalresNC$pvalue_corrected,decreasing=FALSE),]

Mcogres <- Mcogres[order(Mcogres$pvalue_corrected,decreasing=FALSE),]
McogresNC <- McogresNC[order(McogresNC$pvalue_corrected,decreasing=FALSE),]
Mglobalres <- Mglobalres[order(Mglobalres$pvalue_corrected,decreasing=FALSE),]
MglobalresNC <- MglobalresNC[order(MglobalresNC$pvalue_corrected,decreasing=FALSE),]

Intcogres <- Intcogres[order(Intcogres$pvalue_corrected,decreasing=FALSE),]
IntcogresNC <- IntcogresNC[order(IntcogresNC$pvalue_corrected,decreasing=FALSE),]
Intglobalres <- Intglobalres[order(Intglobalres$pvalue_corrected,decreasing=FALSE),]
IntglobalresNC <- IntglobalresNC[order(IntglobalresNC$pvalue_corrected,decreasing=FALSE),]

###do an FDR correction
Fcogres$P.Fdr <- p.adjust(Fcogres$pvalue_corrected, method="fdr")
FcogresNC$P.Fdr <- p.adjust(FcogresNC$pvalue_corrected, method="fdr")
Fglobalres$P.Fdr <- p.adjust(Fglobalres$pvalue_corrected, method="fdr")
FglobalresNC$P.Fdr <- p.adjust(FglobalresNC$pvalue_corrected, method="fdr")

Mcogres$P.Fdr <- p.adjust(Mcogres$pvalue_corrected, method="fdr")
McogresNC$P.Fdr <- p.adjust(McogresNC$pvalue_corrected, method="fdr")
Mglobalres$P.Fdr <- p.adjust(Mglobalres$pvalue_corrected, method="fdr")
MglobalresNC$P.Fdr <- p.adjust(MglobalresNC$pvalue_corrected, method="fdr")

Intcogres$P.Fdr <- p.adjust(Intcogres$pvalue_corrected, method="fdr")
IntcogresNC$P.Fdr <- p.adjust(IntcogresNC$pvalue_corrected, method="fdr")
Intglobalres$P.Fdr <- p.adjust(Intglobalres$pvalue_corrected, method="fdr")
IntglobalresNC$P.Fdr <- p.adjust(IntglobalresNC$pvalue_corrected, method="fdr")

###subset all dfs to pathways with P<0.05
Fcogres <- Fcogres[Fcogres$P.Fdr<0.05,]
FcogresNC <- FcogresNC[FcogresNC$P.Fdr<0.05,]
Fglobalres <- Fglobalres[Fglobalres$P.Fdr<0.05,]
FglobalresNC <- FglobalresNC[FglobalresNC$P.Fdr<0.05,]

Mcogres <- Mcogres[Mcogres$P.Fdr<0.05,]
McogresNC <- McogresNC[McogresNC$P.Fdr<0.05,]
Mglobalres <- Mglobalres[Mglobalres$P.Fdr<0.05,]
MglobalresNC <- MglobalresNC[MglobalresNC$P.Fdr<0.05,]

Intcogres <- Intcogres[Intcogres$P.Fdr<0.05,]
IntcogresNC <- IntcogresNC[IntcogresNC$P.Fdr<0.05,]
Intglobalres <- Intglobalres[Intglobalres$P.Fdr<0.05,]
IntglobalresNC <- IntglobalresNC[IntglobalresNC$P.Fdr<0.05,]

###get overlaps
F_Int_cogres <- Fcogres[Fcogres$trait %in% Intcogres$trait,]
M_Int_cogres <- Mcogres[Mcogres$Ftrait %in% Intcogres$trait,]

F_Int_cogresNC <- FcogresNC[FcogresNC$trait %in% IntcogresNC$trait,]
M_Int_cogresNC <- McogresNC[McogresNC$Ctrait %in% IntcogresNC$trait,]

F_Int_globalres <- Fglobalres[Fglobalres$trait %in% Intglobalres$trait,]
M_Int_globalres <- Mglobalres[Mglobalres$trait %in% Intglobalres$trait,]

F_Int_globalresNC <- FglobalresNC[FglobalresNC$trait %in% IntglobalresNC$trait,]
M_Int_globalresNC <- MglobalresNC[MglobalresNC$trait %in% IntglobalresNC$trait,]

###write out to excel sheets
list_of_datasets1 <- list("Residual Cog. Resilience"=F_Int_cogres, "Residual Cog. Resilience (CN)"=F_Int_cogresNC,
                          "Combined Resilience"=F_Int_globalres, "Combined Resilience (CN)"=F_Int_globalresNC)
write.xlsx(list_of_datasets1,paste0(dir,"TABLES/excel_docs/Female_Int_overlap_top_traits.xlsx"))

list_of_datasets2 <- list("Residual Cog. Resilience"=M_Int_cogres, "Residual Cog. Resilience (CN)"=M_Int_cogresNC,
                          "Combined Resilience"=M_Int_globalres, "Combined Resilience (CN)"=M_Int_globalresNC)
write.xlsx(list_of_datasets2,paste0(dir,"TABLES/excel_docs/Male_Int_overlap_top_traits.xlsx"))


