#!/bin/bash
#By Jaclyn Eissman, December 7, 2021
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --constraint=skylake
#SBATCH --time=4:00:00
#SBATCH --mem=10GB
#SBATCH --array=1-65%20
#SBATCH --job-name=gnova_all_traits_females_globalresNC
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/logfiles/females_globalresNC_%A_%a.out

#Sets up job array to run on computing cluster
trait_list=$(cat /data/h_vmac/eissmajm/SUMSTATS/trait_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}')

#Run bash script for every line of trait_list
sh /data/h_vmac/eissmajm/Sex_Diff_Final/GNOVA/scripts/gnova_females_globalresNC.sh $trait_list
