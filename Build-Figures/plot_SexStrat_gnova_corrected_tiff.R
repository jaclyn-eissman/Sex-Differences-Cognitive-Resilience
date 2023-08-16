#packages
library(data.table)
library(ggplot2)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#create function
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

#run function on all files
F_cogres <- prepare_files(paste0(dir,"GNOVA/females/females.cogres.combined.txt"),"F")
F_cogresNC <- prepare_files(paste0(dir,"GNOVA/females/females.cogresNC.combined.txt"),"F")
F_globalres <- prepare_files(paste0(dir,"GNOVA/females/females.globalres.combined.txt"),"F")
F_globalresNC <- prepare_files(paste0(dir,"GNOVA/females/females.globalresNC.combined.txt"),"F")

M_cogres <- prepare_files(paste0(dir,"GNOVA/males/males.cogres.combined.txt"),"M")
M_cogresNC <- prepare_files(paste0(dir,"GNOVA/males/males.cogresNC.combined.txt"),"M")
M_globalres <- prepare_files(paste0(dir,"GNOVA/males/males.globalres.combined.txt"),"M")
M_globalresNC <- prepare_files(paste0(dir,"GNOVA/males/males.globalresNC.combined.txt"),"M")

#combine males and females into 1 dataframe
cogres <- rbind(F_cogres,M_cogres)
cogresNC <- rbind(F_cogresNC,M_cogresNC)
globalres <- rbind(F_globalres,M_globalres)
globalresNC <- rbind(F_globalresNC,M_globalresNC)

#create sex by p-value groups
cogres$Group <- factor(paste(cogres$sex,cogres$p_group,sep="_"))
cogresNC$Group <- factor(paste(cogresNC$sex,cogresNC$p_group,sep="_"))
globalres$Group <- factor(paste(globalres$sex,globalres$p_group,sep="_"))
globalresNC$Group <- factor(paste(globalresNC$sex,globalresNC$p_group,sep="_"))

#set y-axis 
cogres$trait_level <- factor(cogres$trait, levels=M_cogres$trait[order(M_cogres$rho_corrected)])
cogresNC$trait_level <- factor(cogresNC$trait, levels=M_cogresNC$trait[order(M_cogresNC$rho_corrected)])
globalres$trait_level <- factor(globalres$trait, levels=M_globalres$trait[order(M_globalres$rho_corrected)])
globalresNC$trait_level <- factor(globalresNC$trait, levels=M_globalresNC$trait[order(M_globalresNC$rho_corrected)])

#plot
tiff(paste0(dir,"FIGURES/output/SexStrat.COGRES_corrected.tiff"),width=9.5,height=7,units="in",res=1000)
ggplot(cogres, aes(x=rho_corrected, y=trait_level, colour=Group)) + 
  ggtitle("Genetic Correlation with Residual Cognitive Resilience") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), size=1.0) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Traits") +
  scale_colour_manual(breaks=c("F_0","F_1","F_2","M_0","M_1","M_2"), 
                      limits=c("F_0","F_1","F_2","M_0","M_1","M_2"),
                      labels=c("Females: P>0.05","Females: P<0.05","Females: P.FDR<0.05","Males: P>0.05","Males: P<0.05","Males: P.FDR<0.05"), 
                      values = c("grey","maroon1","maroon4","grey","dodgerblue1","dodgerblue4"))
dev.off()

tiff(paste0(dir,"FIGURES/output/SexStrat.COGRES_NC_corrected.tiff"),width=9.5,height=7,units="in",res=1000)
ggplot(cogresNC, aes(x=rho_corrected, y=trait_level, colour=Group)) + 
  ggtitle("Genetic Correlation with Residual Cog. Resilience (CN)") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), size=1.0) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Traits") +
  scale_colour_manual(breaks=c("F_0","F_1","F_2","M_0","M_1","M_2"), 
                      limits=c("F_0","F_1","F_2","M_0","M_1","M_2"),
                      labels=c("Females: P>0.05","Females: P<0.05","Females: P.FDR<0.05","Males: P>0.05","Males: P<0.05","Males: P.FDR<0.05"), 
                      values = c("grey","maroon1","maroon4","grey","dodgerblue1","dodgerblue4"))
dev.off()

tiff(paste0(dir,"FIGURES/output/SexStrat.GLOBALRES_corrected.tiff"),width=9.5,height=7,units="in",res=1000)
ggplot(globalres, aes(x=rho_corrected, y=trait_level, colour=Group)) + 
  ggtitle("Genetic Correlation with Combined Resilience") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), size=1.0) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Traits") +
  scale_colour_manual(breaks=c("F_0","F_1","F_2","M_0","M_1","M_2"), 
                      limits=c("F_0","F_1","F_2","M_0","M_1","M_2"),
                      labels=c("Females: P>0.05","Females: P<0.05","Females: P.FDR<0.05","Males: P>0.05","Males: P<0.05","Males: P.FDR<0.05"), 
                      values = c("grey","maroon1","maroon4","grey","dodgerblue1","dodgerblue4"))
dev.off()

tiff(paste0(dir,"FIGURES/output/SexStrat.GLOBALRES_NC_corrected.tiff"),width=9.5,height=7,units="in",res=1000)
ggplot(globalresNC, aes(x=rho_corrected, y=trait_level, colour=Group)) + 
  ggtitle("Genetic Correlation with Combined Resilience (Cognitively Normal)") +
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), size=1.0) +
  geom_vline(xintercept=0) + theme_bw() +  xlab("Genetic Covariance") + ylab("Complex Traits") +
  scale_colour_manual(breaks=c("F_0","F_1","F_2","M_0","M_1","M_2"), 
                      limits=c("F_0","F_1","F_2","M_0","M_1","M_2"),
                      labels=c("Females: P>0.05","Females: P<0.05","Females: P.FDR<0.05","Males: P>0.05","Males: P<0.05","Males: P.FDR<0.05"), 
                      values = c("grey","maroon1","maroon4","grey","dodgerblue1","dodgerblue4"))
dev.off()

