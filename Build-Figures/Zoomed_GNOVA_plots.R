#By Jaclyn Eissman, December 7, 2021
###Genetic correlation plots for paper

#Load ackages
library(data.table)
library(ggplot2)

#Set directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#Create function
prepare_files <- function(file,sex) {
  temp <- read.table(file)
  temp <- temp[,c("V17","V3","V4","V6")]
  names(temp) <- c("trait","rho_corrected","se_rho","pvalue_corrected")
  temp$ci_upper <- temp$rho_corrected + (temp$se_rho*1.96)
  temp$ci_lower <- temp$rho_corrected - (temp$se_rho*1.96)
  temp <- temp[order(temp$pvalue_corrected,decreasing=F),]
  temp$P.Fdr <- p.adjust(temp$pvalue_corrected, method="fdr")
  temp$p_group <- 0
  temp$p_group[temp$pvalue_corrected<0.05] <- 1
  temp$p_group[temp$P.Fdr<0.05] <- 2
  temp$sex <- sex
  temp
}

#Run function on all files
F_cogres <- prepare_files(paste0(dir,"GNOVA/females/females.cogres.combined.txt"),"F")
M_cogres <- prepare_files(paste0(dir,"GNOVA/males/males.cogres.combined.txt"),"M")
cogres <- rbind(F_cogres,M_cogres)

F_globalres <- prepare_files(paste0(dir,"GNOVA/females/females.globalres.combined.txt"),"F")
M_globalres <- prepare_files(paste0(dir,"GNOVA/males/males.globalres.combined.txt"),"M")
globalres <- rbind(F_globalres,M_globalres)

#Rename traits
cogres$trait[cogres$trait=="AlzheimersDisease"] <- "Alzheimer's Disease"
cogres$trait[cogres$trait=="FTD"] <- "Frontotemporal Dementia"

globalres$trait[globalres$trait=="MS"] <- "Autoimmune: Multiple Sclerosis"
globalres$trait[globalres$trait=="CeliacDisease"] <- "Autoimmune: Celiac Disease"

globalres$trait[globalres$trait=="RestingHrSDNN"] <- "Heart-Rate Variability: SDNN"
globalres$trait[globalres$trait=="RestingHrRMSSD"] <- "Heart-Rate Variability: RMSSD"
globalres$trait[globalres$trait=="RestingHRpvRSAHF"] <- "Heart-Rate Variability: pvRSAHF"

#Create sex by p-value groups
cogres$Group <- factor(paste(cogres$sex,cogres$p_group,sep="_"))
cogres_subset <- cogres[cogres$trait=="Alzheimer's Disease"| cogres$trait=="Frontotemporal Dementia",]

globalres$Group <- factor(paste(globalres$sex,globalres$p_group,sep="_"))
globalres_subset <- globalres[globalres$trait== "Heart-Rate Variability: SDNN" | globalres$trait=="Heart-Rate Variability: RMSSD" |
                                 globalres$trait=="Heart-Rate Variability: pvRSAHF" | globalres$trait=="Autoimmune: Multiple Sclerosis" | 
                                globalres$trait=="Autoimmune: Celiac Disease" | globalres$trait=="Autoimmune: Lupus",]

#Plot
tiff(paste0(dir,"FIGURES/output/Main_cogres_GNOVA.tiff"),width=10,height=2.5,units="in",res=1000)
ggplot(cogres_subset, aes(x=rho_corrected, y=trait, colour=Group)) + 
  ggtitle("Residual Cognitive Resilience") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), width=0.2,size=1) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Trait") +
  scale_colour_manual(breaks=c("F_0","F_2","M_0","M_2"), 
                      limits=c("F_0","F_2","M_0","M_2"),
                      labels=c(expression(paste("Females: ",italic("P"),">0.05")),
                               expression(paste("Females: ",italic("P.FDR"),"<0.05")),
                               expression(paste("Males: ",italic("P"),">0.05")),
                               expression(paste("Males: ",italic("P.FDR"),"<0.05"))), 
                               values = c("grey","hotpink1","grey","deepskyblue2")) + 
  theme(axis.text.y=element_text(colour="black",size=12)) + theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold"))
dev.off()

tiff(paste0(dir,"FIGURES/output/Main_globalres_GNOVA.tiff"),width=10,height=2.5,units="in",res=1000)
ggplot(globalres_subset, aes(x=rho_corrected, y=trait, colour=Group)) + 
  ggtitle("Combined Resilience") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), width=0.2,size=1) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Trait") +
  scale_colour_manual(breaks=c("F_0","F_2","M_0","M_2"), 
                      limits=c("F_0","F_2","M_0","M_2"),
                      labels=c(expression(paste("Females: ",italic("P"),">0.05")),
                               expression(paste("Females: ",italic("P.FDR"),"<0.05")),
                               expression(paste("Males: ",italic("P"),">0.05")),
                               expression(paste("Males: ",italic("P.FDR"),"<0.05"))), 
                      values = c("grey","hotpink1","grey","deepskyblue2")) + 
  theme(axis.text.y=element_text(colour="black",size=12)) + theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) 
dev.off()
