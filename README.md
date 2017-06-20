# SLURM-examples

The purpose of this repository is to collect examples of how to run SLURM jobs on CSG clusters.
Students, visitors and staff members are welcome to use scripts from this repository in their work, and also contribute their own scripts.

If you want to share your SLURM script, then it is your responsibility to ensure that the script works and correctly allocates cluster resources.

Before allocating hundreds of jobs to the SLURM queue, it is a good idea to test your submission script using a small subset of your input files. Make sure that SLURM arguments for the number of CPUs, cores and etc. are specified adequately and will not harm other users.

## Submitting jobs

### A simple job from the command line
Just run a command like: 
```
sbatch --partition=nomosix --job-name=myjob --mem=4G --time=5-0:0 --output=myjob.slurm.log --wrap="Rscript /net/wonderland/home/foo/myscript.R"
```
- `--partition=<partition name>` (Default is `nomosix`)
    - Use `scontrol show partitions | less` to see a list of available partitions.
- `--job-name=<job name>`: A name for the job. (Default is a random number) 
- `--time=<days>-<hours>:<minutes>`: time limit, after which the job will be killed. (Default is 25 hours)
- `--mem` can use `G` for GB or `M` for MB. (default is `2G`)
- `--output=<filename>`: where to write STDOUT and STDERR (default is `slurm-<job_id>.out`)

SLURM has short versions for some of its options eg:
```
sbatch -p nomosix -J myjob --mem=4G -t 5-0:0 -o myjob.slurm.log --wrap="Rscript /net/wonderland/home/foo/myscript.R"
```

### A simple job from a bash script
```
sbatch --partition=nomosix --job-name=myjob --mem=4G --time=5-0:0 --output=myjob.slurm.log --wrap="Rscript /net/wonderland/home/foo/myscript.R"
```
is equivalent to 
```
sbatch myscript.sh
```
if `myscript.sh` contains:
```
#!/bin/bash
#SBATCH --partition=nomosix
#SBATCH --job-name=myjob
#SBATCH --mem=4G
#SBATCH --time=5-0:0
#SBATCH --output=myjob.slurm.log
Rscript /net/wonderland/home/foo/myscript.R
```

:frog: _Bash script size must be less than 4MB. If you have a large script, then: (a) try using short versions of SLURM options, make your bash variable names short, avoid using long file paths and file names; (b) or try to split it. Quack quack_ 


### A job that use multiple cores (on a single machine)
Some common single-node multi-threaded jobs:
- programs that use multi-threaded linear algebra libraries (MKL, BLAS, ATLAS, etc.)
    - `R` on our cluster can use multiple threads for algebra if you set the environment variable `export OMP_NUM_THREADS=8` (or whatever other value).
    - In case you are not sure if your program is using multi-threaded linear algebra libraries, then execute `ldd <program path>`. The multi-threaded programs will have at least one of the following listed (or very similar): *libpthread, libblas, libgomp, libmkl, libatlas*.
- parallel make i.e. `make -j` (e.g. EPACTS)
- programs that use OpenMP
- programs that use pthreads

:frog: _If a job uses multiple threads, but you don't tell SLURM, SLURM will allocate too many jobs to that node. That will cause problems for all jobs on that node.  Don't do that. Quack quack_

SLURM options for multi-threaded programs:
- `--cpus-per-task`: the number of cores your job will use (default is 1)
- all the options listed above.

eg, `sbatch --cpus-per-task=8 --mem=32G myjob.sh` will allocate 8 CPUs (cores) on a single node with 32GB of RAM (4GB per thread) for a program named `myjob.sh`.

Making your job use the correct number of threads:
- When using multi-threaded linear algebra libraries, you may need to additionally restrict the number of threads using environment variables such as `OMP_NUM_THREADS`. Please, spend some time reading documentation of the specific library you are using to understand what environment variables need to be changed.
- When using parallel make, set `make -j <number_of_cores>`.


### A job that use multiple nodes (ie, MPI)

MPI can use multiple cores across different nodes, so it can be scheduled differently than single-node multi-threaded jobs.

There are three main SLURM options for multi-process/multi-threaded programs:

* `--ntasks`: the number of processes that the program will launch, which can be on separate machines (defaults to 1).
* `--cpus-per-task`: the number of cores each process will use (defaults to 1).
* `--mem-per-cpu`: the amount of memory per core, in MB (or add `G` for GB).

eg, `sbatch --ntasks=8 --cpus-per-task=1 --mem-per-cpu=4G myjob.sh` will allocate 8 CPUs (cores), which can be on different nodes.  Each will have 4GB of RAM, for a total of 32GB.


### Many jobs

The best and recommended way to submit many jobs (>100) is using SLURM's jobs array feature. The job arrays allow managing big number of jobs more effectively and faster. 

To specify job array use `--array` as follows:

1. Tell SLURM how many jobs you will have in array:
    - `--array=0-9`. There are 10 jobs in array. The first job has index 0, and the last job has index 9.
    - `--array=5-8`. There are 4 jobs in array. The first job has index 5, and the last job has index 8.
    - `--array=2,4,6`. There are 3 jobs in array with indices 2, 4 and 6.
2. Inside your script or command, use `$SLURM_ARRAY_TASK_ID` bash variable that stores index to the current job in array. For example, `$SLURM_ARRAY_TASK_ID` can be used to specify input file for job in array (job 0 will process input_file_0.txt, job 1 will process input_file_1.txt and so on):
```
sbatch --array=0-9 --wrap="Rscript myscript.R input_file_$SLURM_ARRAY_TASK_ID.txt"
```


## Monitoring jobs

Two most important commands for monitoring your job status are `squeue` and `scontrol show job`.

- `squeue -l -u <username>`. Shows  all your jobs that are in the SLURM queue.
- `squeue -l -u <username> -p <partition name>`. Shows all your jobs that are in the specific partition (in case you used multiple) in the SLURM queue.

- `scontrol show job -dd <job_id>`. Shows all information about specific SLURM job. It is worth paying attention to the following information:
    - *Requeue*. Shows how many times your job was re-queued. Some jobs may have higher priority and may pre-empt (i.e. cancel) your running jobs and put them back to the queue. If your job takes too long time and *Requeue* is greater than 1 then, most probably, the reason why your job takes so long is because it was cancelled and re-queued several times.
    - *TimeLimit*. Shows time limit of your job.
    - *Command*. The SLURM script that was executed. (only for `sbatch script.sh`)
    - *StdErr*. File where STDERR is written.
    - *StdOut*. File where STDOUT is written.
    - *BatchScript*. The command that was executed. (only for `sbatch --wrap="script.sh args..."`)

## Canceling jobs

To cancel a job use `scancel`:

- `scancel <jobid>`. Cancels your job with provided identifier.
- `scancel -u <username>`. Cancels all your jobs.
- `scancel -u <username> -p <partition>`. Cancels all your jobs in the specified partition.
- `scancel --state=PENDING -u <username>`. Cancels all your jobs that are pending (i.e. not running and waiting in the queue).


## FAQ

1. *My job is close to its time limit. How can I extend it?*

    Run `scontrol update jobid=<job id> TimeLimit=<days>-<hours>:<minutes>`. The new time limit must be greater than the current! Otherwise, SLURM will cancel your job immediately. If you don't have permission to run this command, then contact the administrator (in this case, please do this at least one day before the time limit expires).

2. *What are these terms?*

    node = machine = computer

    number of threads ≈ number of cores ≈ number of cpus

3. *Where are the docs?*

    [here](https://slurm.schedmd.com/sbatch.html)
