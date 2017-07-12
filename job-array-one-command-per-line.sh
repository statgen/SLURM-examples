#!/bin/bash
#SBATCH --time=5-0:0
#SBATCH --array=1-10

declare -a commands
commands[1]="Rscript myscript.R input_file_A.txt"
commands[2]="Rscript myscript.R input_file_B.txt"
commands[3]="Rscript myscript.R input_file_C.txt"
commands[4]="Rscript myscript.R input_file_D.txt"
commands[5]="Rscript myscript.R input_file_E.txt"
commands[6]="Rscript myscript.R input_file_F.txt"
commands[7]="Rscript myscript.R input_file_G.txt"
commands[8]="Rscript myscript.R input_file_H.txt"
commands[9]="Rscript myscript.R input_file_I.txt"
commands[10]="Rscript myscript.R input_file_J.txt"

bash -c "${commands[${SLURM_ARRAY_TASK_ID}]}"
