#packages
library(ggplot2)
library(data.table)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in mem data and organize
autopsy_mem <- readRDS(paste0(dir,"TABLES/data/ACT_ROSMAP_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
autopsy_mem <- autopsy_mem[,c("ID","mem","SEX","CERAD","Dataset","dx")]
names(autopsy_mem) <- c("ID","MEM","SEX","CERAD","Dataset","dx")

pet_mem <- readRDS(paste0(dir,"TABLES/data/ADNI_A4_Combined_Resilience_Phenotype_Covariates_newmem.rds"))
pet_mem <- pet_mem[,c("ID","mem","sex","std_mixture_suvr","Dataset","dx","VISCODE")]
names(pet_mem) <- c("ID","MEM","SEX","SUVR","Dataset","dx","VISCODE")
pet_mem$SEX <- ifelse(pet_mem$SEX==1,"Male", ifelse(pet_mem$SEX==2,"Female",pet_mem$SEX))

#read in exf/pacc data
autopsy_exf <- readRDS(paste0(dir,"TABLES/data//ACT_ROSMAP_Combined_Resilience_Phenotype_Covariates.rds"))
autopsy_exf <- autopsy_exf[,c("IID","exf_std_2act")]
names(autopsy_exf) <- c("ID","EXF")

adni_exf <- read.csv(paste0(dir,"TABLES/data/adni_epad_long_cocal_scores20180926.csv"))
examdate <- readRDS(paste0(dir, "TABLES/data/Examdate.rds"))
adni_exf <- merge(adni_exf,examdate,by=c("RID","VISCODE2"))
adni_exf <- adni_exf[,c("RID","exf_std_2act","VISCODE")]
names(adni_exf) <- c("ID","EXF","VISCODE")

pet_pacc <- readRDS(paste0(dir,"TABLES/data/ADNI_A4_Combined_Resilience_Phenotype_Covariates.rds"))
pet_pacc <- pet_pacc [,c("ID","PACCRN","VISCODE")]
names(pet_pacc) <- c("ID","PACC","VISCODE")

#combine
autopsy <- merge(autopsy_mem,autopsy_exf,by=c("ID"))
pet <- merge(pet_mem,adni_exf,by=c("ID","VISCODE"),all=T)
pet <- merge(pet,pet_pacc,by=c("ID","VISCODE"),all=T)
pet_doms <- pet[,c("MEM","EXF","PACC")] 
pet <- pet[which(rowMeans(!is.na(pet_doms)) > 0.5), ]

#read in final covar file and subset to people present in that
covar <- fread(paste0(dir,"TABLES/data/All_datasets_MPlus_Resilience_Covariates_updated.txt"))
covar$FID <- gsub("A4_","",covar$FID)
covar$FID <- gsub("ACT_","",covar$FID)
covar$FID <- gsub("ADNI_","",covar$FID)
covar$FID <- gsub("ROSMAP_","",covar$FID)
autopsy <- autopsy[autopsy$ID %in% covar$FID,]
autopsy$SEX <- ifelse(autopsy$SEX==1,"Male","Female")
pet <- pet[pet$ID %in% covar$FID,]

###PLOTS

#AUTOPSY: CERAD vs. MEM
tiff(paste0(dir,"FIGURES/output/MEM_CERAD_ALL.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=autopsy, aes(x=as.factor(CERAD), y=MEM, fill=SEX)) + geom_boxplot() + xlab("CERAD stages") + 
  ylab("Harmonized memory") + ggtitle("CERAD staging on harmonized memory (all)") + 
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + 
  scale_fill_manual(values=c("hotpink1","deepskyblue2"),name="SEX") + theme_bw() 
dev.off()

tiff(paste0(dir,"FIGURES/output/MEM_CERAD_CN.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=autopsy[autopsy$dx==1,], aes(x=as.factor(CERAD), y=MEM, fill=SEX)) + geom_boxplot() + xlab("CERAD stages") + 
  ylab("Harmonized memory") + ggtitle("CERAD staging on harmonized memory (CN)") + 
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + 
  scale_fill_manual(values=c("hotpink1","deepskyblue2"),name="SEX") + theme_bw() 
dev.off()

#AUTOPSY: CERAD vs. EXF
tiff(paste0(dir,"FIGURES/output//EXF_CERAD_ALL.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=autopsy, aes(x=as.factor(CERAD), y=EXF, fill=SEX)) + geom_boxplot() + xlab("CERAD stages") + 
  ylab("Harmonized executive function") + ggtitle("CERAD staging on executive function (all)") + 
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + 
  scale_fill_manual(values=c("hotpink1","deepskyblue2"),name="SEX") + theme_bw() 
dev.off()

tiff(paste0(dir,"FIGURES/output/EXF_CERAD_CN.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=autopsy[autopsy$dx==1,], aes(x=as.factor(CERAD), y=EXF, fill=SEX)) + geom_boxplot() + xlab("CERAD stages") + 
  ylab("Harmonized executive function") + ggtitle("CERAD staging on executive function (CN)") + 
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + 
  scale_fill_manual(values=c("hotpink1","deepskyblue2"),name="SEX") + theme_bw() 
dev.off()

#PET: SUVR vs. MEM
tiff(paste0(dir,"FIGURES/output/MEM_SUVR_ALL.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet, aes(x=SUVR, y=MEM, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized memory") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized memory (all)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() 
dev.off()
   
tiff(paste0(dir,"FIGURES/output/MEM_SUVR_CN.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet[pet$dx==1,], aes(x=SUVR, y=MEM, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized memory") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized memory (CN)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() 
dev.off()

#PET: SUVR vs. EXF
tiff(paste0(dir,"FIGURES/output/EXF_SUVR_ALL.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet, aes(x=SUVR, y=EXF, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized executive function") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized executive function (all)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() + xlim(-2.5,13.3)
dev.off()

tiff(paste0(dir,"FIGURES/output/EXF_SUVR_CN.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet[pet$dx==1,], aes(x=SUVR, y=EXF, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized executive function") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized executive function (CN)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() + xlim(-2.5,13.3)
dev.off()

#PET: SUVR vs. PACC
tiff(paste0(dir,"FIGURES/output/PACC_SUVR_ALL.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet, aes(x=SUVR, y=PACC, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized PACC") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized PACC (all)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() 
dev.off()

tiff(paste0(dir,"FIGURES/output/PACC_SUVR_CN.tiff"),width=8,height=7,units="in",res=300)
ggplot(data=pet[pet$dx==1,], aes(x=SUVR, y=PACC, color=SEX)) + geom_point() + geom_smooth(method="lm") +
  xlab("Harmonized in-vivo amyloid PET") + ylab("Harmonized PACC") + 
  ggtitle("Harmonized in-vivo amyloid PET on harmonized PACC (CN)") +
  scale_color_manual(values=c("hotpink1","deepskyblue2")) + theme_bw() 
dev.off()
