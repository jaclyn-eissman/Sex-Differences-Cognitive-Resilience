#packages
library(data.table)
library(metafor)
library(forestplot)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in raw files
autopsy <- fread(paste0(dir,"TABLES/data/ACT_ROSMAP_final_rs11225156.raw"))
pet <- fread(paste0(dir,"TABLES/data/ADNI_A4_final_rs11225156.raw"))

#read in covar/pheno files 
covar <- fread(paste0(dir,"TABLES/data/All_datasets_MPlus_Resilience_Covariates_updated.txt"))
pheno <- fread(paste0(dir,"TABLES/data/All_datasets_MPlus_Resilience_Phenotypes_updated.txt"))

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
act <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=act, na.action=na.omit)
rosmap <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=rosmap, na.action=na.omit)
adni <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=adni, na.action=na.omit)
a4 <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=a4, na.action=na.omit)

#Run autopsy and pet lm 
autopsy <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=autopsy, na.action=na.omit)
pet <- lm(GLOBALRES_NC ~ age + PC1 + PC2 + PC3 + rs11225156_T*sex, data=pet, na.action=na.omit)

#Pull coefficients and run meta-analysis
Beta <- c(summary(autopsy)$coefficients["rs11225156_T:sex", "Estimate"], 
          summary(pet)$coefficients["rs11225156_T:sex", "Estimate"])
SE <- c(summary(autopsy)$coefficients["rs11225156_T:sex", "Std. Error"],
        summary(pet)$coefficients["rs11225156_T:sex", "Std. Error"])
meta <- rma(yi=Beta,sei=SE,method="FE")

#rs11225156
to_plot <- as.data.frame(cbind(Beta = unlist(c(summary(autopsy)$coefficients["rs11225156_T:sex", "Estimate"], 
                                               summary(act)$coefficients["rs11225156_T:sex", "Estimate"], 
                                               summary(rosmap)$coefficients["rs11225156_T:sex", "Estimate"],  
                                               summary(pet)$coefficients["rs11225156_T:sex", "Estimate"] , 
                                               summary(adni)$coefficients["rs11225156_T:sex", "Estimate"], 
                                               summary(a4)$coefficients["rs11225156_T:sex", "Estimate"],
                                               unname(coef(summary(meta))["estimate"]))),
                               lower = unlist(c(confint(autopsy)["rs11225156_T:sex","2.5 %"], 
                                                confint(act)["rs11225156_T:sex","2.5 %"], 
                                                confint(rosmap)["rs11225156_T:sex","2.5 %"], 
                                                confint(pet)["rs11225156_T:sex","2.5 %"], 
                                                confint(adni)["rs11225156_T:sex","2.5 %"], 
                                                confint(a4)["rs11225156_T:sex","2.5 %"], 
                                                unname(coef(summary(meta))["ci.lb"]))),
                               upper = unlist(c(confint(autopsy)["rs11225156_T:sex","97.5 %"], 
                                                confint(act)["rs11225156_T:sex","97.5 %"], 
                                                confint(rosmap)["rs11225156_T:sex","97.5 %"], 
                                                confint(pet)["rs11225156_T:sex","97.5 %"], 
                                                confint(adni)["rs11225156_T:sex","97.5 %"], 
                                                confint(a4)["rs11225156_T:sex","97.5 %"], 
                                                unname(coef(summary(meta))["ci.ub"])))))

tabletext <- list(c("Autopsy Datasets", "         ACT", "         ROSMAP",  "PET Datasets", "         ADNI", "         A4", "Fixed-Effects Estimate"))

tiff(paste0(dir,"FIGURES/output/Forest_plot_rs11225156.tiff"),width=8,height=7,units="in",res=300)
forestplot(tabletext, mean=to_plot$Beta, is.summary=c(TRUE,rep(FALSE,2),TRUE,rep(FALSE,2),TRUE),
           col=fpColors(box="darkorchid2",line="darkorchid2",summary="darkorchid4"),
           lower=(to_plot$lower),upper=(to_plot$upper),xlab="Beta [95% CI]", ci.vertices=TRUE,
           xticks = c(-0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6),  
           ci.vertices.height=0.07, boxsize=0.1, title="rs11225156 by Sex: Residual Cognitive Resilience (CN)")
dev.off()

