###Sensitivity analysis: APOE*SEX

#packages
library(data.table)
library(metafor)
library(readxl)

#directory
directory <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in phenotype and covariate files
covar <- fread(paste0(directory,"DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt"))
pheno <- fread(paste0(directory,"DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt"))
covar_pheno <- merge(pheno,covar,by=c("FID","IID")) #N=5024

#read in apoe info (data from cohort folders, and ADNI is from 2018 folder)
a4 <- read.csv(paste0(directory,"TABLES/data/A4_SUBJINFO.csv"))
act <- read_excel(paste0(directory,"TABLES/data/ACT_APOE_20210204.xlsx"))
adni <- readRDS(paste0(directory,"TABLES/data/Apoe.rds"))
rosmap <- read.csv(paste0(directory,"TABLES/data/dataset_295_basic_05-07-2019.csv"))

#add dataset label to ID and to df
a4$ID <- paste0("A4_",a4$BID)
a4$dataset <- "A4"
act$ID <- paste0("ACT_",act$e165_ID)
act$dataset <- "ACT"
adni$ID <- paste0("ADNI_",adni$RID)
adni$dataset <- "ADNI"
rosmap$ID <- paste0("ROSMAP_",rosmap$projid)
rosmap$dataset <- "ROSMAP"

#create apoe4 and apoe2 bins
a4 <- a4[!is.na(a4$APOEGN),]
a4$apoe4_bin <- ifelse(a4$APOEGN=="E2/E4" | a4$APOEGN=="E3/E4", 1, ifelse(a4$APOEGN=="E4/E4", 2, 0))
a4$apoe2_bin <- ifelse(a4$APOEGN=="E2/E4" | a4$APOEGN=="E2/E3" | a4$APOEGN=="E2/E2", 1, 0)
a4 <- a4[,c("ID","apoe4_bin","apoe2_bin","dataset")]

act <- act[!is.na(act$apoe_raw),]
act$apoe4_bin <- ifelse(act$apoe_raw=="2/4" | act$apoe_raw=="3/4", 1, ifelse(act$apoe_raw=="4/4", 2, 0))
act$apoe2_bin <- ifelse(act$apoe_raw=="2/4" | act$apoe_raw=="2/3" | act$apoe_raw=="2/2", 1, 0)
act <- act[,c("ID","apoe4_bin","apoe2_bin","dataset")]

adni <- adni[!is.na(adni$APGEN1) & !is.na(adni$APGEN2),]
adni$APGEN <- paste(adni$APGEN1,adni$APGEN2,sep="/")
adni$apoe4_bin <- ifelse(adni$APGEN=="2/4" | adni$APGEN=="3/4", 1, ifelse(adni$APGEN=="4/4", 2, 0))
adni$apoe2_bin <- ifelse(adni$APGEN=="2/4" | adni$APGEN=="2/3" | adni$APGEN=="2/2", 1, 0)
adni <- adni[,c("ID","apoe4_bin","apoe2_bin","dataset")]

rosmap <- rosmap[!is.na(rosmap$apoe_genotype),]
rosmap$apoe4_bin <- ifelse(rosmap$apoe_genotype=="24" | rosmap$apoe_genotype=="34", 1, ifelse(rosmap$apoe_genotype=="44", 2, 0))
rosmap$apoe2_bin <- ifelse(rosmap$apoe_genotyp=="24" | rosmap$apoe_genotyp=="23" | rosmap$apoe_genotype=="22", 1, 0)
rosmap <- rosmap[,c("ID","apoe4_bin","apoe2_bin","dataset")]

#combine with covar/pheno file
data <- rbind(a4,act,adni,rosmap) #N=14491
data <- merge(covar_pheno,data,by.x="FID",by.y="ID",all.x=T) #N=5024

###APOE4 
autopsy_cogres <- lm(COGRES ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_cogres <- lm(COGRES ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_cogresNC <- lm(COGRES_NC ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_cogresNC <- lm(COGRES_NC ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_globalres <- lm(GLOBALRES ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_globalres <- lm(GLOBALRES ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_globalresNC <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_globalresNC <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + apoe4_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

#meta-analysis
cogres <- rma(yi=c(summary(autopsy_cogres)$coefficients["apoe4_bin:sex", "Estimate"], 
              summary(pet_cogres)$coefficients["apoe4_bin:sex", "Estimate"]),
              sei=c(summary(autopsy_cogres)$coefficients["apoe4_bin:sex", "Std. Error"],
              summary(pet_cogres)$coefficients["apoe4_bin:sex", "Std. Error"]),method="FE")
cogresNC <- rma(yi=c(summary(autopsy_cogresNC)$coefficients["apoe4_bin:sex", "Estimate"], 
                   summary(pet_cogresNC)$coefficients["apoe4_bin:sex", "Estimate"]),
              sei=c(summary(autopsy_cogresNC)$coefficients["apoe4_bin:sex", "Std. Error"],
                    summary(pet_cogresNC)$coefficients["apoe4_bin:sex", "Std. Error"]),method="FE")
globalres <- rma(yi=c(summary(autopsy_globalres)$coefficients["apoe4_bin:sex", "Estimate"], 
                   summary(pet_globalres)$coefficients["apoe4_bin:sex", "Estimate"]),
              sei=c(summary(autopsy_globalres)$coefficients["apoe4_bin:sex", "Std. Error"],
                    summary(pet_globalres)$coefficients["apoe4_bin:sex", "Std. Error"]),method="FE")
globalresNC <- rma(yi=c(summary(autopsy_globalresNC)$coefficients["apoe4_bin:sex", "Estimate"], 
                      summary(pet_globalresNC)$coefficients["apoe4_bin:sex", "Estimate"]),
                 sei=c(summary(autopsy_globalresNC)$coefficients["apoe4_bin:sex", "Std. Error"],
                       summary(pet_globalresNC)$coefficients["apoe4_bin:sex", "Std. Error"]),method="FE")


###APOE2
autopsy_cogres <- lm(COGRES ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_cogres <- lm(COGRES ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_cogresNC <- lm(COGRES_NC ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_cogresNC <- lm(COGRES_NC ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_globalres <- lm(GLOBALRES ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_globalres <- lm(GLOBALRES ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

autopsy_globalresNC <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="ACT"|data$dataset=="ROSMAP",], na.action=na.omit)
pet_globalresNC <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + apoe2_bin*sex, data=data[data$dataset=="A4"|data$dataset=="ADNI",], na.action=na.omit)

#meta-analysis
cogres <- rma(yi=c(summary(autopsy_cogres)$coefficients["apoe2_bin:sex", "Estimate"], 
                   summary(pet_cogres)$coefficients["apoe2_bin:sex", "Estimate"]),
              sei=c(summary(autopsy_cogres)$coefficients["apoe2_bin:sex", "Std. Error"],
                    summary(pet_cogres)$coefficients["apoe2_bin:sex", "Std. Error"]),method="FE")
cogresNC <- rma(yi=c(summary(autopsy_cogresNC)$coefficients["apoe2_bin:sex", "Estimate"], 
                     summary(pet_cogresNC)$coefficients["apoe2_bin:sex", "Estimate"]),
                sei=c(summary(autopsy_cogresNC)$coefficients["apoe2_bin:sex", "Std. Error"],
                      summary(pet_cogresNC)$coefficients["apoe2_bin:sex", "Std. Error"]),method="FE")
globalres <- rma(yi=c(summary(autopsy_globalres)$coefficients["apoe2_bin:sex", "Estimate"], 
                      summary(pet_globalres)$coefficients["apoe2_bin:sex", "Estimate"]),
                 sei=c(summary(autopsy_globalres)$coefficients["apoe2_bin:sex", "Std. Error"],
                       summary(pet_globalres)$coefficients["apoe2_bin:sex", "Std. Error"]),method="FE")
globalresNC <- rma(yi=c(summary(autopsy_globalresNC)$coefficients["apoe2_bin:sex", "Estimate"], 
                        summary(pet_globalresNC)$coefficients["apoe2_bin:sex", "Estimate"]),
                   sei=c(summary(autopsy_globalresNC)$coefficients["apoe2_bin:sex", "Std. Error"],
                         summary(pet_globalresNC)$coefficients["apoe2_bin:sex", "Std. Error"]),method="FE")

