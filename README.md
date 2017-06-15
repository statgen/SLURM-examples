# SLURM-examples

The purpose of this repository is to collect examples of how to run SLURM jobs on CSG clusters.
Students, visitors and stuff members are welcomed to use scripts from this repository in their work, and also contribute their own scripts.

If you want to share your SLURM script, then it is your responsibility to ensure that the script works and correctly allocates cluster resources.

Before allocating hundreds of jobs to the SLURM queue, it is a good idea to test your submission script using a small subset of your input files. Make sure that SLURM arguments for the number of CPUs, cores and etc. are specified adequately and will not harm other users. 


## Multi-threaded jobs

When running multi-threaded jobs, it is important to let SLURM know. If SLURM is not aware about multiple threads, then it will keep allocating new jobs on the same compute node and overwhelm it (making many users very unhappy).

Some common multi-threaded jobs are:
- programs that use multi-threaded linear algebra libraries (MKL, BLAS, ATLAS, etc.)
- parallel make i.e. `make -j` (e.g. EPACTS)
- programs that use OpenMP
- programs that use pthreads

There are three main SLURM options for multi-threaded programs:

* `--ntasks`: the number of processes that program will launch (choose 1 unless using MPI)
* `--cpus-per-task`: the number of cores each process will use (defaults to 1)
* `--mem-per-cpu`: the amount of memory per core, in MB (or add `G` for GB).

`sbatch --ntasks=1 --cpus-per-task=8 --mem-per-cpu=4G` will allocate 8 CPUs (cores) on a single node for a program that uses 8 threads and 32GB of RAM (4GB per thread).

When using multi-threaded linear algebra libraries, you may need to additionally restrict the number of threads using environment variables such as `OMP_NUM_THREADS`. Please, spend some time reading documentation of the specific library you are using to understand what environment variables need to be changed.
