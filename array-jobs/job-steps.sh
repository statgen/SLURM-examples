#!/bin/sh

#SBATCH --mail-type=ALL
#SBATCH --mail-user=uniqname@umich.edu
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2000
#SBATCH --array=1-100:2

R ./script.R input_file_${SLURM_ARRAY_TASK_ID}.txt
