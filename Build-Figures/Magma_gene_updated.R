###MAGMA gene plot for paper

#packages
library(data.table)
library(ggplot2)
library(gridExtra)

#directory
dir <- "/Users/jackieeissman/Box Sync/Hohman_Lab/Students/Jaclyn Eissman/Sex_Diff_Final/"

#read in data
male_genes <- fread(paste0(dir,"MAGMA/GLOBALRES.males_2sets.genes.out_with_FDR"))
male_genes <- male_genes[,c("CHR","START","GENE","ZSTAT","P")]
male_X <- fread(paste0(dir,"XCHROM/GLOBALRES.females_2sets.X.genes.out"))
male_X <- male_X[,c("CHR","START","GENE","ZSTAT","P")]
male_X$CHR <- NA
male_X$CHR <- 23

female_genes <- fread(paste0(dir,"MAGMA/GLOBALRES.females_2sets.genes.out_with_FDR"))
female_genes <- female_genes[,c("CHR","START","GENE","ZSTAT","P")]
female_X <- fread(paste0(dir,"XCHROM/GLOBALRES.females_2sets.X.genes.out"))
female_X <- female_X[,c("CHR","START","GENE","ZSTAT","P")]
female_X$CHR <- NA
female_X$CHR <- 23

#do FDR correction
male_genes <- rbind(male_genes,male_X)
male_genes$P.Fdr <- p.adjust(male_genes$P, method="fdr")
female_genes <- rbind(female_genes,female_X)
female_genes$P.Fdr <- p.adjust(female_genes$P, method="fdr")

#order by CHR
female_genes$CHR <- as.numeric(female_genes$CHR)
female_genes <- female_genes[order(female_genes$CHR),]
male_genes$CHR <- as.numeric(male_genes$CHR)
male_genes <- male_genes[order(male_genes$CHR),]

#plot
tiff(paste0(dir,"FIGURES/output/GLOBALRES_MAGMA.tiff"),width=7,height=4,units="in",res=1000)
p1 <- arrangeGrob(ggplot(female_genes, aes(x=CHR, y=-log10(P))) + geom_point(position="jitter",color="hotpink1") + theme_bw() +
                    theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="none") + ylim(0,6.5) + 
                    scale_x_discrete(limits=female_genes$CHR) + geom_hline(yintercept=-log10(2.68514e-06)) + 
                    ggtitle("Gene-Level Test on Combined Resilience")) 
p2 <- arrangeGrob(ggplot(male_genes, aes(x=CHR, y=-log10(P))) + geom_point(position="jitter",color="deepskyblue2") + theme_bw() +
                    theme(axis.text.x=element_text(angle=45, hjust=1)) + theme(legend.position="none") + ylim(0,6.5) + 
                    scale_x_discrete(limits=female_genes$CHR) + geom_hline(yintercept=-log10(2.68514e-06))) 
grid.arrange(p1, p2, ncol=1)
dev.off()



