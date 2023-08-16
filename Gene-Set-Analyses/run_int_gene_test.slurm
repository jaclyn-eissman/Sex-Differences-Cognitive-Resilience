#!/bin/bash
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --time=6:00:00
#SBATCH --mem=10GB
#SBATCH --array=1-4
#SBATCH --job-name=int_gene_test
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/logfiles/int_gene_%A_%a.out

int_file_list=$(cat /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/int_file_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
sh /data/h_vmac/eissmajm/Sex_Diff_Final/MAGMA/scripts/run_int_gene_test.sh $int_file_list
