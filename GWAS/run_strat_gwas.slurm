#!/bin/bash
#By Jaclyn Eissman, December 7, 2021
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=8:00:00
#SBATCH --mem=20GB
#SBATCH --array=1-4
#SBATCH --job-name=gwas_sexstrat
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/logfiles/strat_gwas_%A_%a.out

#Sets up job array to run on computing cluster
pheno_list=$(cat /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/pheno_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')

#Runs bash script with each line of pheno_list
sh /data/h_vmac/eissmajm/Sex_Diff_Final/GWAS/run_strat_gwas.sh $pheno_list
