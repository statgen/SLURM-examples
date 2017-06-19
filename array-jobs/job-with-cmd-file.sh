#!/bin/sh

#SBATCH --mail-type=ALL
#SBATCH --mail-user=uniqname@umich.edu
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2000
#SBATCH --array=1-10

srun $(head -n $SLURM_ARRAY_TASK_ID cmds.txt | tail -n 1)
