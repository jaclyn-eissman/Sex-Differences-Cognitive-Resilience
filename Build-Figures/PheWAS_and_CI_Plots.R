###PheWAS and CI Plots for UKBB 

###packages
library(data.table)
library(ggplot2)
library(openxlsx)
library(gridExtra)
library(ggrepel)
library(plyr)

###directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/"

###read in excel file with groups
excel <- read.xlsx(paste0(dir,"UKBB/UKBB_all_with_pheno_groups_v2.xlsx"))
females <- excel[excel$Sex=="female",] #subset to females
females$File <- gsub(".tsv.bgz","",females$File) #remove the extensions from file name

###function
process_ukbb <- function(data,ext) {
  data <- read.table(paste0(dir,data),header=F)
  names(data) <- c("annot_name","rho","rho_corrected","se_rho","pvalue_cov","pvalue_corrected_cov","corr",
                   "se_corr","corr_corrected","se_corr_corrected","pvalue_corr","pvalue_corrected_corr","h2_1","h2_2","p","p0","trait")
  data$trait <- gsub(ext,"",data$trait)
  data$trait <- gsub("[[:space:]]+$", "",data$trait)
  data <- merge(data,females,by.x="trait",by.y="File")
  data <- data[order(data$pvalue_corrected_cov),]
  data$P.FWE <- p.adjust(data$pvalue_corrected_cov,method="bonferroni")
  data$ci_upper <- data$rho_corrected + (data$se_rho*1.96)
  data$ci_lower <- data$rho_corrected - (data$se_rho*1.96)
  data$direction <- ifelse(data$rho_corrected>0,1,2)
  data
}

###run
females_cogres <- process_ukbb("Sex_Diff_Final/UKBB/females/UKBB.FEMALES.COGRES.ALL.txt",".COGRES.txt")
nrow(females_cogres[females_cogres$P.FWE<0.05,]) #21
females_sig <- females_cogres[females_cogres$P.FWE<0.05,]
females_cogres[grepl("Treatment/medication code: climesse tablet",females_cogres$Phenotype.Description),]
females_cogres[grepl("Ever addicted to illicit or recreational drugs",females_cogres$Phenotype.Description),]
females_cogres[grepl("Alcohol consumed",females_cogres$Phenotype.Description),]

###read in excel file with groups
excel <- read.xlsx(paste0(dir,"UKBB/UKBB_all_with_pheno_groups_v2.xlsx"))
males <- excel[excel$Sex=="male",] #subset to males
males$File <- gsub(".tsv.bgz","",males$File) #remove the extensions from file name

###function
process_ukbb <- function(data,ext) {
  data <- read.table(paste0(dir,data),header=F)
  names(data) <- c("annot_name","rho","rho_corrected","se_rho","pvalue_cov","pvalue_corrected_cov","corr",
                   "se_corr","corr_corrected","se_corr_corrected","pvalue_corr","pvalue_corrected_corr","h2_1","h2_2","p","p0","trait")
  data$trait <- gsub(ext,"",data$trait)
  data$trait <- gsub("[[:space:]]+$", "",data$trait)
  data <- merge(data,males,by.x="trait",by.y="File")
  data <- data[order(data$pvalue_corrected_cov),]
  data$P.FWE <- p.adjust(data$pvalue_corrected_cov,method="bonferroni")
  data$ci_upper <- data$rho_corrected + (data$se_rho*1.96)
  data$ci_lower <- data$rho_corrected - (data$se_rho*1.96)
  data$direction <- ifelse(data$rho_corrected>0,1,2)
  data
}

###run
males_cogres <- process_ukbb("Sex_Diff_Final/UKBB/males/UKBB.MALES.COGRES.ALL.txt",".COGRES.txt")
nrow(males_cogres[males_cogres$P.FWE<0.05,]) #53
males_sig <- males_cogres[males_cogres$P.FWE<0.05,]
males_cogres[grepl("Ever addicted to illicit or recreational drugs",males_cogres$Phenotype.Description),]
males_cogres[grepl("Alcohol consumed",males_cogres$Phenotype.Description),]

###text to annotate
females_cogres$Phenotype.Description[females_cogres$Phenotype.Description=="Treatment/medication code: climesse tablet"] <- "Hormone Replacement Therapy"
females_cogres$Phenotype.Description[females_cogres$Phenotype.Description=="Ever addicted to illicit or recreational drugs"] <- "Illicit Drug Addiction"
females_cogres$Phenotype.Description[females_cogres$Phenotype.Description=="Alcohol consumed"] <- "Alcohol Consumption"
males_cogres$Phenotype.Description[males_cogres$Phenotype.Description=="Ever addicted to illicit or recreational drugs"] <- "Illicit Drug Addiction"
males_cogres$Phenotype.Description[males_cogres$Phenotype.Description=="Alcohol consumed"] <- "Alcohol Consumption"
to_label_females <- c("Hormone-Replacement Therapy","Illicit Drug Addiction","Alcohol Consumption")
to_label_males <- c("Illicit Drug Addiction","Alcohol Consumption")

###PheWAS plot
png(paste0(dir,"Sex_Diff_Final/FIGURES/output/Combined_PheWAS_UKBB_COGRES_for_Poster.png"),width=10,height=7,units="in",res=1000)
F1 <- arrangeGrob(ggplot(females_cogres, aes(x=Phenotype.Group, y=-log10(pvalue_corrected_cov),color=Phenotype.Group,group=direction)) + 
                    geom_point(position="jitter",aes(color=Phenotype.Group,shape=as.factor(direction))) + theme_bw() + 
                    scale_shape_manual(values=c(2,6)) + geom_hline(yintercept=-log10(0.05/3318), linetype="dashed") + 
                    theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="none") + xlab("FEMALES") + ylab("-log(P)") +
                    theme(axis.title.x=element_text(colour="black",size=14,face="bold")))
M1 <- arrangeGrob(ggplot(males_cogres, aes(x=Phenotype.Group, y=-log10(pvalue_corrected_cov),color=Phenotype.Group,group=direction)) + 
                    geom_point(position="jitter",aes(color=Phenotype.Group,shape=as.factor(direction))) + theme_bw() + 
                    scale_shape_manual(values=c(2,6)) + geom_hline(yintercept=-log10(0.05/3174), linetype="dashed") + 
                    theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="none") + xlab("MALES") + ylab("-log(P)") +
                    theme(axis.title.x=element_text(colour="black",size=14,face="bold")))
grid.arrange(F1, M1, ncol=1)
dev.off()

###CI plot
to_label <- c("Hormone Replacement Therapy","Illicit Drug Addiction","Alcohol Consumption")
females_sig <- females_cogres[females_cogres$Phenotype.Description %in% to_label,]
males_sig <- males_cogres[males_cogres$Phenotype.Description %in% to_label,]
cogres <- rbind.fill(males_sig,females_sig)

png(paste0(dir,"Sex_Diff_Final/FIGURES/output/Combined_CI_UKBB_COGRES_for_Poster.png"),width=10,height=2.5,units="in",res=1000)
ggplot(cogres, aes(x=rho_corrected, y=Phenotype.Description, colour=Sex)) + 
  geom_linerange(aes(xmin=ci_lower, xmax=ci_upper)) +
  geom_pointrange(aes(xmin=ci_lower, xmax=ci_upper), size=0.2) +
  geom_errorbar(aes(xmin=ci_lower, xmax=ci_upper), width=0.2,size=1) +
  geom_vline(xintercept=0) + theme_bw() + theme(axis.text.y=element_text(colour="black",size=12)) +  
  theme(axis.title.y=element_text(colour="black",size=14,face="bold")) +
  theme(axis.title.x=element_text(colour="black",size=14,face="bold")) + 
  scale_colour_manual(values=c("hotpink1","deepskyblue2")) + ylab("Phenotype") + xlab("Genetic Covariance")
dev.off()



