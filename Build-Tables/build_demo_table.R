#packages
library(data.table)
library(plyr)
library(openxlsx)

#directory
directory <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in rds file with final composites and covar info 
#from genetic resilinece project update -- amyloid resilience -- data folder
autopsy <- readRDS(paste0(directory,"TABLES/data/ACT_ROSMAP_Combined_Resilience_Phenotype_Covariates_newmem.rds")) 
pet <- readRDS(paste0(directory,"TABLES/data/ADNI_A4_Combined_Resilience_Phenotype_Covariates_newmem.rds"))

#select down
autopsy <- autopsy[,c("ID","age_death","CERAD","educ","dx","SEX")]
pet <- pet[,c("ID","age","Amyloid_bin","pteducat","dx","sex","apoe4_add")]

#get apoe bin -- data from ROSMAP and ACT folders
pet$apoe_bin <- ifelse(pet$apoe4_add==1 | pet$apoe4_add==2,1,0)
pet$apoe4_add <- NULL
rosmap <- read.csv(paste0(directory,"TABLES/data/dataset_295_basic_05-07-2019.csv"))
rosmap$apoe_bin <- ifelse(rosmap$apoe_genotype==22 | rosmap$apoe_genotype==23 | rosmap$apoe_genotype==33, 0,1)
act <- read.xlsx(paste0(directory,"TABLES/data/ACT_APOE_20210204.xlsx"))
act$apoe_bin <- ifelse(act$apoe_raw=="2/2" | act$apoe_raw=="2/3" | act$apoe_raw=="3/3", 0,1)
rosmap <- as.data.frame(rosmap[,c("projid","apoe_bin")])
names(rosmap) <- c("ID","apoe_bin")
act <- as.data.frame(act[,c("e165_ID","apoe_bin")])
names(act) <- c("ID","apoe_bin")
autopsy_bin <- rbind(rosmap,act)
autopsy$ID <- as.character(autopsy$ID)
autopsy <- merge(autopsy,autopsy_bin,by="ID",all=T)

#rename and combine
names(autopsy) <- c("ID","age","amyloid_status","educ","dx","sex","apoe_bin")
autopsy$amyloid_status <- ifelse(autopsy$amyloid_status==3 | autopsy$amyloid_status==4,1,0)
names(pet) <- c("ID","age","amyloid_status","educ","dx","sex","apoe_bin")
pet$amyloid_status <- ifelse(pet$amyloid_status==2,1,0)
data <- rbind(autopsy,pet)

#read in final phenotype file, pull resilience scores, and subset to people present in file
pheno <- fread(paste0(directory,"DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt")) #N=5024
pheno$FID <- gsub("A4_","",pheno$FID)
pheno$FID <- gsub("ACT_","",pheno$FID)
pheno$FID <- gsub("ADNI_","",pheno$FID)
pheno$FID <- gsub("ROSMAP_","",pheno$FID)
data <- data[data$ID %in% pheno$FID,] #N=5024
data <- merge(data,pheno[,c("FID","COGRES","GLOBALRES")],by.x="ID",by.y="FID") #5024

#separate by sex
data$sex <- ifelse(data$sex=="Male" | data$sex==1,1,2)
male <- data[data$sex==1,]
female <- data[data$sex==2,]
rm(pheno)
rm(pet)
rm(autopsy)
rm(rosmap)
rm(act)
rm(autopsy_bin)

#pull age info
mean(data$age,na.rm=T)
sd(data$age,na.rm=T)
mean(male$age,na.rm=T)
sd(male$age,na.rm=T)
mean(female$age,na.rm=T)
sd(female$age,na.rm=T)
t.test(male$age,female$age) #not sig

#pull education info
mean(data$educ,na.rm=T) 
sd(data$educ,na.rm=T) 
mean(male$educ,na.rm=T) 
sd(male$educ,na.rm=T) 
mean(female$educ,na.rm=T)
sd(female$educ,na.rm=T)
t.test(male$educ,female$educ) #sig

#pull residual cognitive resilience score 
mean(data$COGRES,na.rm=T)
sd(data$COGRES,na.rm=T)
mean(male$COGRES,na.rm=T)
sd(male$COGRES,na.rm=T)
mean(female$COGRES,na.rm=T)
sd(female$COGRES,na.rm=T)
t.test(male$COGRES,female$COGRES) #not sig

#pull global resilience score 
mean(data$GLOBALRES,na.rm=T)
sd(data$GLOBALRES,na.rm=T)
mean(male$GLOBALRES,na.rm=T)
sd(male$GLOBALRES,na.rm=T)
mean(female$GLOBALRES,na.rm=T)
sd(female$GLOBALRES,na.rm=T)
t.test(male$GLOBALRES,female$GLOBALRES) #sig

#pull amyloid status
nrow(data[data$amyloid_status==1,])
(nrow(data[data$amyloid_status==1,])/5024)*100
nrow(male[male$amyloid_status==1,])
(nrow(male[male$amyloid_status==1,])/2093)*100
nrow(female[female$amyloid_status==1,])
(nrow(female[female$amyloid_status==1,])/2931)*100
chisq.test(table(data$sex, data$amyloid_status)) #sig (barely)

#pull AD dx
nrow(data[data$dx==3,])
(nrow(data[data$dx==3,])/5024)*100
nrow(male[male$dx==3,])
(nrow(male[male$dx==3,])/2093)*100
nrow(female[female$dx==3,])
(nrow(female[female$dx==3,])/2931)*100
chisq.test(table(data$sex, data$dx)) #sig

#pull apoe e4 carrier status
nrow(data[data$apoe_bin==1,])
(nrow(data[data$apoe_bin==1,])/5024)*100
nrow(male[male$apoe_bin==1,])
(nrow(male[male$apoe_bin==1,])/2093)*100
nrow(female[female$apoe_bin==1,])
(nrow(female[female$apoe_bin==1,])/2931)*100
chisq.test(table(data$sex, data$apoe_bin)) #not sig

