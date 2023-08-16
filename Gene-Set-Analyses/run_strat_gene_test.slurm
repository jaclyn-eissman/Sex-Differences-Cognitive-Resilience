#!/bin/bash
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --time=6:00:00
#SBATCH --mem=10GB
#SBATCH --array=1-8
#SBATCH --job-name=strat_gene_test
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/logfiles/strat_gene_%A_%a.out

strat_file_list=$(cat /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/strat_file_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
sh /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/run_strat_gene_test.sh $strat_file_list
