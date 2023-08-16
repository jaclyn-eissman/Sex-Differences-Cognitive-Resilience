#packages
library(data.table)
library(metafor)
library(forestplot)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in raw files
autopsy <- fread(paste0(dir,"DATA/ACT_ROSMAP_final_rs827389.raw"))
pet <- fread(paste0(dir,"DATA/ADNI_A4_final_rs827389.raw"))

#read in covar/pheno files 
covar <- fread(paste0(dir,"DATA/All_datasets_MPlus_Resilience_Covariates_updated.txt"))
pheno <- fread(paste0(dir,"DATA/All_datasets_MPlus_Resilience_Phenotypes_updated.txt"))

#combine
covar_pheno <- merge(covar,pheno,by=c("FID","IID")) #5024
autopsy <- merge(autopsy,covar_pheno,by=c("FID","IID")) #N=1402
pet <- merge(pet,covar_pheno,by=c("FID","IID")) #N=3622

#pull individual cohorts
a4 <- pet[grepl("A4_",pet$FID),]
act <- autopsy[grepl("ACT_",autopsy$FID),]
adni <- pet[grepl("ADNI_",pet$FID),]
rosmap <- autopsy[grepl("ROSMAP_",autopsy$FID),]

#Run individual cohort lm
act_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=act[act$sex==2,], na.action=na.omit)
rosmap_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=rosmap[rosmap$sex==2,], na.action=na.omit)
adni_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=adni[adni$sex==2,], na.action=na.omit)
a4_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=a4[a4$sex==2,], na.action=na.omit)

act_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=act[act$sex==1,], na.action=na.omit)
rosmap_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=rosmap[rosmap$sex==1,], na.action=na.omit)
adni_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=adni[adni$sex==1,], na.action=na.omit)
a4_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=a4[a4$sex==1,], na.action=na.omit)

#Run autopsy and pet lm 
autopsy_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=autopsy[autopsy$sex==2,], na.action=na.omit)
pet_females <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=pet[pet$sex==2,], na.action=na.omit)

autopsy_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=autopsy[autopsy$sex==1,], na.action=na.omit)
pet_males <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs827389_A, data=pet[pet$sex==1,], na.action=na.omit)

#Pull coefficients 
Beta_females <- c(summary(autopsy_females)$coefficients["rs827389_A", "Estimate"], 
                  summary(pet_females)$coefficients["rs827389_A", "Estimate"])
SE_females <- c(summary(autopsy_females)$coefficients["rs827389_A", "Std. Error"],
                summary(pet_females)$coefficients["rs827389_A", "Std. Error"])
Beta_males <- c(summary(autopsy_males)$coefficients["rs827389_A", "Estimate"], 
                summary(pet_males)$coefficients["rs827389_A", "Estimate"])
SE_males <- c(summary(autopsy_males)$coefficients["rs827389_A", "Std. Error"],
              summary(pet_males)$coefficients["rs827389_A", "Std. Error"])

##Run meta-analyses 
meta_females <- rma(yi=Beta_females,sei=SE_females,method="FE")
meta_males <- rma(yi=Beta_males,sei=SE_males,method="FE")

#rs827389 
to_plot_females <- as.data.frame(cbind(Beta = unlist(c(summary(autopsy_females)$coefficients["rs827389_A", "Estimate"], 
                                              summary(act_females)$coefficients["rs827389_A", "Estimate"], 
                                              summary(rosmap_females)$coefficients["rs827389_A", "Estimate"],  
                                              summary(pet_females)$coefficients["rs827389_A", "Estimate"] , 
                                              summary(adni_females)$coefficients["rs827389_A", "Estimate"], 
                                              summary(a4_females)$coefficients["rs827389_A", "Estimate"],
                                              unname(coef(summary(meta_females))["estimate"]))),
                                              lower = unlist(c(confint(autopsy_females)["rs827389_A","2.5 %"], 
                                              confint(act_females)["rs827389_A","2.5 %"], 
                                              confint(rosmap_females)["rs827389_A","2.5 %"], 
                                              confint(pet_females)["rs827389_A","2.5 %"], 
                                              confint(adni_females)["rs827389_A","2.5 %"], 
                                              confint(a4_females)["rs827389_A","2.5 %"], 
                                              unname(coef(summary(meta_females))["ci.lb"]))),
                                              upper = unlist(c(confint(autopsy_females)["rs827389_A","97.5 %"], 
                                              confint(act_females)["rs827389_A","97.5 %"], 
                                              confint(rosmap_females)["rs827389_A","97.5 %"], 
                                              confint(pet_females)["rs827389_A","97.5 %"], 
                                              confint(adni_females)["rs827389_A","97.5 %"], 
                                              confint(a4_females)["rs827389_A","97.5 %"], 
                                              unname(coef(summary(meta_females))["ci.ub"])))))

to_plot_males <- as.data.frame(cbind(Beta = unlist(c(summary(autopsy_males)$coefficients["rs827389_A", "Estimate"], 
                                            summary(act_males)$coefficients["rs827389_A", "Estimate"], 
                                            summary(rosmap_males)$coefficients["rs827389_A", "Estimate"],  
                                            summary(pet_males)$coefficients["rs827389_A", "Estimate"] , 
                                            summary(adni_males)$coefficients["rs827389_A", "Estimate"], 
                                            summary(a4_males)$coefficients["rs827389_A", "Estimate"], 
                                            unname(coef(summary(meta_males))["estimate"]))),
                                            lower = unlist(c(confint(autopsy_males)["rs827389_A","2.5 %"], 
                                            confint(act_males)["rs827389_A","2.5 %"], 
                                            confint(rosmap_males)["rs827389_A","2.5 %"],  
                                            confint(pet_males)["rs827389_A","2.5 %"], 
                                            confint(adni_males)["rs827389_A","2.5 %"], 
                                            confint(a4_males)["rs827389_A","2.5 %"],  
                                            unname(coef(summary(meta_males))["ci.lb"]))),
                                            upper = unlist(c(confint(autopsy_males)["rs827389_A","97.5 %"], 
                                            confint(act_males)["rs827389_A","97.5 %"], 
                                            confint(rosmap_males)["rs827389_A","97.5 %"],  
                                            confint(pet_males)["rs827389_A","97.5 %"], 
                                            confint(adni_males)["rs827389_A","97.5 %"], 
                                            confint(a4_males)["rs827389_A","97.5 %"], 
                                            unname(coef(summary(meta_males))["ci.ub"])))))

tabletext <- list(c("Autopsy Datasets", "         ACT", "         ROSMAP",  "PET Datasets", "         ADNI", "         A4", "Fixed-Effects Estimate"))

tiff(paste0(dir,"FIGURES/output/Forest_plot_rs827389.tiff"),width=8,height=7,units="in",res=300)
forestplot(tabletext, mean=cbind(to_plot_females$Beta,to_plot_males$Beta), 
           is.summary=c(TRUE,rep(FALSE,2),TRUE,rep(FALSE,2),TRUE),
           col=fpColors(box=c("hotpink1","deepskyblue2"),line=c("hotpink1","deepskyblue2"),
                        summary=c("hotpink1","deepskyblue2")),
           lower=cbind(to_plot_females$lower,to_plot_males$lower),
           upper=cbind(to_plot_females$upper,to_plot_males$upper), xlab="Beta [95% CI]", ci.vertices=TRUE,
           xticks = c(-0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6),  
           ci.vertices.height=0.07, boxsize=0.1, legend=c("Females", "Males"), 
           title="rs827389 on Combined Resilience (Cognitively Normal)")
dev.off()

