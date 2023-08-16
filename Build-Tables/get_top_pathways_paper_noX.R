###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

###read in text files 
Fcogres <- fread(paste0(dir,"MAGMA/COGRES.females_2sets.gsa.out_with_FDR"))
FcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.females_2sets.gsa.out_with_FDR"))
Fglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.gsa.out_with_FDR"))
FglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.females_2sets.gsa.out_with_FDR"))

Mcogres <- fread(paste0(dir,"MAGMA/COGRES.males_2sets.gsa.out_with_FDR"))
McogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.males_2sets.gsa.out_with_FDR"))
Mglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.gsa.out_with_FDR"))
MglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.males_2sets.gsa.out_with_FDR"))

Intcogres <- fread(paste0(dir,"MAGMA/COGRES.interaction_2sets.gsa.out_with_FDR"))
IntcogresNC <- fread(paste0(dir,"MAGMA/COGRES_NC.interaction_2sets.gsa.out_with_FDR"))
Intglobalres <- fread(paste0(dir,"MAGMA/GLOBALRES.interaction_2sets.gsa.out_with_FDR"))
IntglobalresNC <- fread(paste0(dir,"MAGMA/GLOBALRES_NC.interaction_2sets.gsa.out_with_FDR"))

###subset all dfs to pathways with P<0.05
Fcogres <- Fcogres[Fcogres$P<0.05,]
FcogresNC <- FcogresNC[FcogresNC$P<0.05,]
Fglobalres <- Fglobalres[Fglobalres$P<0.05,]
FglobalresNC <- FglobalresNC[FglobalresNC$P<0.05,]

Mcogres <- Mcogres[Mcogres$P<0.05,]
McogresNC <- McogresNC[McogresNC$P<0.05,]
Mglobalres <- Mglobalres[Mglobalres$P<0.05,]
MglobalresNC <- MglobalresNC[MglobalresNC$P<0.05,]

Intcogres <- Intcogres[Intcogres$P<0.05,]
IntcogresNC <- IntcogresNC[IntcogresNC$P<0.05,]
Intglobalres <- Intglobalres[Intglobalres$P<0.05,]
IntglobalresNC <- IntglobalresNC[IntglobalresNC$P<0.05,]

###get overlaps
F_Int_cogres <- Fcogres[Fcogres$FULL_NAME %in% Intcogres$FULL_NAME,]
M_Int_cogres <- Mcogres[Mcogres$FULL_NAME %in% Intcogres$FULL_NAME,]

F_Int_cogresNC <- FcogresNC[FcogresNC$FULL_NAME %in% IntcogresNC$FULL_NAME,]
M_Int_cogresNC <- McogresNC[McogresNC$FULL_NAME %in% IntcogresNC$FULL_NAME,]

F_Int_globalres <- Fglobalres[Fglobalres$FULL_NAME %in% Intglobalres$FULL_NAME,]
M_Int_globalres <- Mglobalres[Mglobalres$FULL_NAME %in% Intglobalres$FULL_NAME,]

F_Int_globalresNC <- FglobalresNC[FglobalresNC$FULL_NAME %in% IntglobalresNC$FULL_NAME,]
M_Int_globalresNC <- MglobalresNC[MglobalresNC$FULL_NAME %in% IntglobalresNC$FULL_NAME,]

###order by P value in sex, not in int
F_Int_cogres <- F_Int_cogres[order(F_Int_cogres$P,decreasing=FALSE),]
F_Int_cogresNC <- F_Int_cogresNC[order(F_Int_cogresNC$P,decreasing=FALSE),]
F_Int_globalres <- F_Int_globalres[order(F_Int_globalres$P,decreasing=FALSE),]
F_Int_globalresNC <- F_Int_globalresNC[order(F_Int_globalresNC$P,decreasing=FALSE),]

M_Int_cogres <- M_Int_cogres[order(M_Int_cogres$P,decreasing=FALSE),]
M_Int_cogresNC <- M_Int_cogresNC[order(M_Int_cogresNC$P,decreasing=FALSE),]
M_Int_globalres <- M_Int_globalres[order(M_Int_globalres$P,decreasing=FALSE),]
M_Int_globalresNC <- M_Int_globalresNC[order(M_Int_globalresNC$P,decreasing=FALSE),]

###write out to excel sheets
list_of_datasets1 <- list("Residual Cog. Resilience"=F_Int_cogres, "Residual Cog. Resilience (CN)"=F_Int_cogresNC,
                         "Combined Resilience"=F_Int_globalres, "Combined Resilience (CN)"=F_Int_globalresNC)
write.xlsx(list_of_datasets1,paste0(dir,"TABLES/excel_docs/Female_Int_overlap_top_pathways.xlsx"))

list_of_datasets2 <- list("Residual Cog. Resilience"=M_Int_cogres, "Residual Cog. Resilience (CN)"=M_Int_cogresNC,
                         "Combined Resilience"=M_Int_globalres, "Combined Resilience (CN)"=M_Int_globalresNC)
write.xlsx(list_of_datasets2,paste0(dir,"TABLES/excel_docs/Male_Int_overlap_top_pathways.xlsx"))

