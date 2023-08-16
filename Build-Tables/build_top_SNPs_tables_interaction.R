###packages
library(data.table)
library(openxlsx)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/TABLES/"

###read in interaction files
INTcogres <- fread(paste0(dir,"data/COGRES.interaction_2sets_TopSNPs.txt"))
INTcogresNC <- fread(paste0(dir,"data/COGRES_NC.interaction_2sets_TopSNPs.txt"))
INTglobalres <- fread(paste0(dir,"data/GLOBALRES.interaction_2sets_TopSNPs.txt"))
INTglobalresNC <- fread(paste0(dir,"data/GLOBALRES_NC.interaction_2sets_TopSNPs.txt"))

###select needed cols
INTcogres <- INTcogres[,c("rs_number","eaf","beta","se","p-value")]
INTcogresNC <- INTcogresNC[,c("rs_number","eaf","beta","se","p-value")]
INTglobalres <- INTglobalres[,c("rs_number","eaf","beta","se","p-value")]
INTglobalresNC <- INTglobalresNC[,c("rs_number","eaf","beta","se","p-value")]

###rename
names(INTcogres) <- c("SNP","MAF(interaction)","BETA(interaction)","SE(interaction)","P(interaction)")
names(INTcogresNC) <- c("SNP","MAF(interaction)","BETA(interaction)","SE(interaction)","P(interaction)")
names(INTglobalres) <- c("SNP","MAF(interaction)","BETA(interaction)","SE(interaction)","P(interaction)")
names(INTglobalresNC) <- c("SNP","MAF(interaction)","BETA(interaction)","SE(interaction)","P(interaction)")

###order by P value
INTcogres <- INTcogres[order(INTcogres$'P(interaction)',decreasing=FALSE),]
INTcogresNC <- INTcogresNC[order(INTcogresNC$'P(interaction)',decreasing=FALSE),]
INTglobalres <- INTglobalres[order(INTglobalres$'P(interaction)',decreasing=FALSE),]
INTglobalresNC <- INTglobalresNC[order(INTglobalresNC$'P(interaction)',decreasing=FALSE),]

###write out to excel sheets
list_of_datasets <- list("9_COGRES"=INTcogres,"10_COGRES_NC"=INTcogresNC,"11_GLOBALRES"=INTglobalres,"12_GLOBALRES_NC"=INTglobalresNC)
write.xlsx(list_of_datasets,paste0(dir,"excel_docs/Supplementary_Tables_9-12.xlsx"))
