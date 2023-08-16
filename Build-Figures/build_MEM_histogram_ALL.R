#packages
library(ggplot2)
library(data.table)
library(plyr)

#Directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in mem data and organize
autopsy_mem <- readRDS(paste0(dir,"TABLES/data/ACT_ROSMAP_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
autopsy_mem <- autopsy_mem[,c("ID","mem","SEX","Dataset","dx")]
names(autopsy_mem) <- c("ID","MEM","SEX","Dataset","dx")
autopsy_mem$SEX <- ifelse(autopsy_mem$SEX==1,"Male", ifelse(autopsy_mem$SEX==2,"Female",autopsy_mem$SEX))

pet_mem <- readRDS(paste0(dir,"TABLES/data/ADNI_A4_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
pet_mem <- pet_mem[,c("ID","mem","sex","Dataset","dx")]
names(pet_mem) <- c("ID","MEM","SEX","Dataset","dx")
pet_mem$SEX <- ifelse(pet_mem$SEX==1,"Male", ifelse(pet_mem$SEX==2,"Female",pet_mem$SEX))

#read in final covar file and subset to people present in that
covar <- fread(paste0(dir,"TABLES/data/All_datasets_MPlus_Resilience_Covariates_updated.txt")) #5024
covar$FID <- gsub("A4_","",covar$FID)
covar$FID <- gsub("ACT_","",covar$FID)
covar$FID <- gsub("ADNI_","",covar$FID)
covar$FID <- gsub("ROSMAP_","",covar$FID)
autopsy_mem <- autopsy_mem[autopsy_mem$ID %in% covar$FID,]
pet_mem <- pet_mem[pet_mem$ID %in% covar$FID,]
data_MEM <- rbind(pet_mem,autopsy_mem) #5024

#Overlaid Histograms -- Males
M_all_MEM <- data_MEM[!is.na(data_MEM$MEM) & data_MEM$SEX=="Male",]
M_all_MEM_means <- ddply(M_all_MEM, "Dataset", summarise, grp.mean=mean(MEM))

tiff(paste0(dir,"FIGURES/output/MEM_Histogram_ALL_Males.tiff"),width=8,height=7,units="in",res=300)
ggplot(M_all_MEM, aes(x=M_MEM, fill=Dataset, color=Dataset)) +
  geom_histogram(alpha=0.3, position="identity", binwidth=.4, aes(x=MEM,y=..density..)) + theme_classic() + 
  geom_vline(data=M_all_MEM_means, aes(xintercept=grp.mean, color=Dataset), linetype="dashed") +
  xlab("Harmonized Memory Scores") + theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
  scale_color_manual(values = c("dodgerblue", "dodgerblue3", "deepskyblue", "deepskyblue4")) + 
  scale_fill_manual(values = c("dodgerblue", "dodgerblue3", "deepskyblue", "deepskyblue4")) + 
  ggtitle("Harmonized Memory in Males (All)")
dev.off()

M_CN_MEM <- data_MEM[!is.na(data_MEM$MEM) & data_MEM$dx==1  & data_MEM$SEX=="Male",]
M_CN_MEM_means <- ddply(M_CN_MEM, "Dataset", summarise, grp.mean=mean(MEM))

tiff(paste0(dir,"FIGURES/output/MEM_Histogram_CN_Males.tiff"),width=8,height=7,units="in",res=300)
ggplot(M_CN_MEM, aes(x=M_MEM, fill=Dataset, color=Dataset)) +
  geom_histogram(alpha=0.3, position="identity", binwidth=.4, aes(x=MEM,y=..density..)) + theme_classic() + 
  geom_vline(data=M_CN_MEM_means, aes(xintercept=grp.mean, color=Dataset), linetype="dashed") +
  xlab("Harmonized Memory Scores") + theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
  scale_color_manual(values = c("dodgerblue", "dodgerblue3", "deepskyblue", "deepskyblue4")) + 
  scale_fill_manual(values = c("dodgerblue", "dodgerblue3", "deepskyblue", "deepskyblue4")) + 
  ggtitle("Harmonized Memory in Males (CN)")
dev.off()

#Overlaid Histograms -- Females
F_all_MEM <- data_MEM[!is.na(data_MEM$MEM) & data_MEM$SEX=="Female",]
F_all_MEM_means <- ddply(F_all_MEM, "Dataset", summarise, grp.mean=mean(MEM))

tiff(paste0(dir,"FIGURES/output/MEM_Histogram_ALL_Females.tiff"),width=8,height=7,units="in",res=300)
ggplot(F_all_MEM , aes(x=MEM, fill=Dataset, color=Dataset)) +
  geom_histogram(alpha=0.3, position="identity", binwidth=.4, aes(x=MEM,y=..density..)) + theme_classic() + 
  geom_vline(data=F_all_MEM_means, aes(xintercept=grp.mean, color=Dataset), linetype="dashed") +
  xlab("Harmonized Memory Scores") + theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
  scale_color_manual(values = c("deeppink", "hotpink3", "hotpink", "deeppink4")) + 
  scale_fill_manual(values = c("deeppink", "hotpink3", "hotpink", "deeppink4")) + 
  ggtitle("Harmonized Memory in Females (All)")
dev.off()

F_CN_MEM <- data_MEM[!is.na(data_MEM$MEM) & data_MEM$dx==1  & data_MEM$SEX=="Female",]
F_CN_MEM_means <- ddply(F_CN_MEM, "Dataset", summarise, grp.mean=mean(MEM))

tiff(paste0(dir,"FIGURES/output/MEM_Histogram_CN_Females.tiff"),width=8,height=7,units="in",res=300)
ggplot(F_CN_MEM, aes(x=MEM, fill=Dataset, color=Dataset)) +
  geom_histogram(alpha=0.3, position="identity", binwidth=.4, aes(x=MEM,y=..density..)) + theme_classic() + 
  geom_vline(data=F_CN_MEM_means, aes(xintercept=grp.mean, color=Dataset), linetype="dashed") +
  xlab("Harmonized Memory Scores") + theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
  scale_color_manual(values = c("deeppink", "hotpink3", "hotpink", "deeppink4")) + 
  scale_fill_manual(values = c("deeppink", "hotpink3", "hotpink", "deeppink4")) + 
  ggtitle("Harmonized Memory in Females (CN)")
dev.off()

