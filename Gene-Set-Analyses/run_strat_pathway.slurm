#!/bin/bash
#By Jaclyn Eissman, December 7, 2021
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --mem=10GB
#SBATCH --array=1-8
#SBATCH --job-name=strat_pathway_test
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/logfiles/strat_pathway_%A_%a.out

#Sets up job array to run on computing cluster
strat_file_list=$(cat /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/strat_file_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')

#Run bash script for every line of strat_file_list
sh /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/run_strat_pathway.sh $strat_file_list
