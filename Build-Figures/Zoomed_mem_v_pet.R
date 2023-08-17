#By Jaclyn Eissman, December 7, 2021

#Load packages
library(ggplot2)
library(data.table)

#Set directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#Read in mememory data and organize
autopsy_mem <- readRDS(paste0(dir,"TABLES/data/ACT_ROSMAP_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
autopsy_mem <- autopsy_mem[,c("ID","mem","SEX","CERAD","Dataset","dx")]
names(autopsy_mem) <- c("ID","MEM","SEX","CERAD","Dataset","dx")
autopsy_mem$SEX <- ifelse(autopsy_mem$SEX==1,"Male","Female")

pet_mem <- readRDS(paste0(dir,"TABLES/data/ADNI_A4_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
pet_mem <- pet_mem[,c("ID","mem","sex","std_mixture_suvr","Dataset","dx","VISCODE")]
names(pet_mem) <- c("ID","MEM","SEX","SUVR","Dataset","dx","VISCODE")
pet_mem$SEX <- ifelse(pet_mem$SEX==1,"Male", ifelse(pet_mem$SEX==2,"Female",pet_mem$SEX))

#Read in final covariate file and subset to people present in that
covar <- fread(paste0(dir,"DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt"))
covar$FID <- gsub("A4_","",covar$FID)
covar$FID <- gsub("ACT_","",covar$FID)
covar$FID <- gsub("ADNI_","",covar$FID)
covar$FID <- gsub("ROSMAP_","",covar$FID)
autopsy <- autopsy_mem[autopsy_mem$ID %in% covar$FID,]
pet <- pet_mem[pet_mem$ID %in% covar$FID,]
#3622 + 1402
#[1] 5024

#PET: SUVR vs. MEM
tiff(paste0(dir,"FIGURES/output/MEM_SUVR_ALL.tiff"),width=8,height=4.5,units="in",res=300)
ggplot(data=pet, aes(x=SUVR, y=MEM, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized Amyloid PET SUVR") + ylab("Harmonized Memory Score") + 
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() + 
  theme(legend.text=element_text(size=14),legend.title=element_text(size=14)) +
  theme(axis.text.y=element_text(colour="black",size=16)) + theme(axis.title.y=element_text(colour="black",size=16,face="bold")) +
  theme(axis.text.x=element_text(colour="black",size=16)) + theme(axis.title.x=element_text(colour="black",size=16,face="bold"))
dev.off()
