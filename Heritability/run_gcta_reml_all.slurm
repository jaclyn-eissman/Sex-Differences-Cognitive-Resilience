#!/bin/bash
#SBATCH --mail-user=jaclyn.m.eissman@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --constraint=skylake
#SBATCH --time=10:00:00
#SBATCH --mem=28GB
#SBATCH --job-name=Run_GCTA_ALL
#SBATCH --output=/data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/Run_GCTA_REML_ALL.out

sh /data/h_vmac/eissmajm/Sex_Diff_Final/GCTA/run_gcta_reml_all.sh
