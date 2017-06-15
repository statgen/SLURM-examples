# SLURM-examples

The purpose of this repository is to collect examples of how to run SLURM jobs on CSG clusters.
Students, visitors and stuff members are welcomed to use scripts from this repository in their work, and also contribute their own scripts.

If you want to share your SLURM script, then it is your responsibility to ensure that the script works and correctly allocates cluster resources.

Before allocating hundreds of jobs to the SLURM queue, it is a good idea to test your submission script using a small subset of your input files. Make sure that SLURM arguments for the number of CPUs, cores and etc. are specified adequately and will not hurm other users. 


## Multi-threaded jobs

When running multi-threaded jobs, it is very important to let SLURM know about this. If SLURM is not aware about multiple threads, then it will keep allocating new jobs on the same compute node and overwhelm it (making many users very unhappy).

When should you consider this section? 
- if you run programs that use multi-threaded linear algebra libraries (MKL, BLAS, ATLAS and etc.)
- if you run parallel make i.e. `make -j` (e.g. EPACTS)
- if you run programs that use pthreads
- if you run programs that use OpenMP

There are three most importat SLURM options for multi-threaded programs: --ntasks, --cpus-per-task, --mem-per-cpu.
`sbatch --ntasks=1 --cpus-per-task=8 --mem-per-cpu=4000` will allocate 8 CPUs (cores) on a single node for a program that uses 8 threads and 4Gb per thread (32 Gb of shared memory).
