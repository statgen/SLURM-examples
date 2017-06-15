# SLURM-examples

The purpose of this repository is to collect examples of how to run SLURM jobs on CSG clusters.
Students, visitors and stuff members are welcomed to use scripts from this repository in their work, and also contribute their own scripts.

If you want to share your SLURM script, then it is your responsibility to ensure that the script works and correctly allocates cluster resources.

Before allocating hundreds of jobs to the SLURM queue, it is a good idea to test your submission script using a small subset of your input files. Make sure that SLURM arguments for the number of CPUs, cores and etc. are specified adequately and will not harm other users. 


## Jobs that use multiple cores on one node

Some common single-node multi-threaded jobs:
- programs that use multi-threaded linear algebra libraries (MKL, BLAS, ATLAS, etc.)
- parallel make i.e. `make -j` (e.g. EPACTS)
- programs that use OpenMP
- programs that use pthreads

If a job uses multiple threads, but you don't tell SLURM, SLURM will allocate too many jobs to that node. That will cause problems for all jobs on that node.  Don't do that.

SLURM options for multi-threaded programs:
- `--cpus-per-task`: the number of cores each job will use (defaults to 1)
- `--mem`: the amount of memory, in MB (or add `G` for GB).

eg, `sbatch --cpus-per-task=8 --mem=32G myjob.sh` will allocate 8 CPUs (cores) on a single node and 32GB of RAM (4GB per thread) for a program named `myjob.sh`.

Making your job use the correct number of threads:
- When using multi-threaded linear algebra libraries, you may need to additionally restrict the number of threads using environment variables such as `OMP_NUM_THREADS`. Please, spend some time reading documentation of the specific library you are using to understand what environment variables need to be changed.
- When using parallel make, set `make -j <number_of_cores>`.


## Jobs that using multiple nodes (ie, MPI)

MPI can use multiple cores across different nodes, so it can be scheduled differently than single-node multi-threaded jobs.

There are three main SLURM options for multi-threaded programs:

* `--ntasks`: the number of processes that program will launch (choose 1 unless using MPI)
* `--cpus-per-task`: the number of cores each process will use (defaults to 1)
* `--mem-per-cpu`: the amount of memory per core, in MB (or add `G` for GB).

eg, `sbatch --ntasks=8 --cpus-per-task=1 --mem-per-cpu=4G myjob.sh` will allocate 8 CPUs (cores), which can be on different nodes.  Each will have 4GB of RAM, for a total of 32GB.
