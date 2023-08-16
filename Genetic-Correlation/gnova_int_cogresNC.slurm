#!/bin/bash
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --constraint=skylake
#SBATCH --time=4:00:00
#SBATCH --mem=10GB
#SBATCH --array=1-65%20
#SBATCH --job-name=gnova_all_traits_int_cogresNC
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/logfiles/int_cogresNC_%A_%a.out

trait_list=$(cat /data/h_vmac/eissmajm/SUMSTATS/trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')
sh /data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/scripts/gnova_int_cogresNC.sh $trait_list
