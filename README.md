# SLURM-examples

The purpose of this repository is to collect examples of how to run SLURM jobs on CSG clusters.
Students, visitors and stuff members are welcomed to use scripts from this repository in their work, and also contribute their own scripts.

If you want to share your SLURM script, then it is your responsibility to ensure that the script works and correctly allocates cluster resources.

Before allocating hundreds of jobs to the SLURM queue, it is a good idea to test your submission script using a small subset of your input files. Make sure that SLURM arguments for the number of CPUs, cores and etc. are specified adequately and will not harm other users. 


## Simple jobs
Just run a command like: `sbatch --mem=4G --time=5-0:0 --wrap="Rscript /net/wonderland/home/foo/myscript.R > x.txt"`.
- `--time=<days>-<hours>:<minutes>`
- `--mem` can use `G` for GB or `M` for MB
- STDOUT and STDERR will be written to `slurm-<job_id>.out` (though in this example, due to `> x.txt` there shouldn't be any)


## Jobs that use multiple cores (on a single machine)
Some common single-node multi-threaded jobs:
- programs that use multi-threaded linear algebra libraries (MKL, BLAS, ATLAS, etc.)
    - `R` on our cluster can use multiple threads for algebra if you set the environment variable `OMP_NUM_THREADS=8` (or whatever other value).
- parallel make i.e. `make -j` (e.g. EPACTS, Gotcloud)
- programs that use OpenMP
- programs that use pthreads

If a job uses multiple threads, but you don't tell SLURM, SLURM will allocate too many jobs to that node. That will cause problems for all jobs on that node.  Don't do that.

SLURM options for multi-threaded programs:
- `--cpus-per-task`: the number of cores your job will use (defaults to 1)
- `--mem`: the total amount of memory, in MB (or add `G` for GB).

eg, `sbatch --cpus-per-task=8 --mem=32G myjob.sh` will allocate 8 CPUs (cores) on a single node with 32GB of RAM (4GB per thread) for a program named `myjob.sh`.

Making your job use the correct number of threads:
- When using multi-threaded linear algebra libraries, you may need to additionally restrict the number of threads using environment variables such as `OMP_NUM_THREADS`. Please, spend some time reading documentation of the specific library you are using to understand what environment variables need to be changed.
- When using parallel make, set `make -j <number_of_cores>`.


## Jobs that use multiple nodes (ie, MPI)

MPI can use multiple cores across different nodes, so it can be scheduled differently than single-node multi-threaded jobs.

There are three main SLURM options for multi-threaded programs:

* `--ntasks`: the number of processes that the program will launch (defaults to 1).
* `--cpus-per-task`: the number of cores each process will use (defaults to 1).
* `--mem-per-cpu`: the amount of memory per core, in MB (or add `G` for GB).

eg, `sbatch --ntasks=8 --cpus-per-task=1 --mem-per-cpu=4G myjob.sh` will allocate 8 CPUs (cores), which can be on different nodes.  Each will have 4GB of RAM, for a total of 32GB.


## Running many jobs
*TODO*
