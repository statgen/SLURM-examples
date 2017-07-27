#!/bin/bash

# This example demonstrates how to use SLURM with EPACTS.
# We assume that: 
#    (a) genotype data is saved in VCF files split by chromosome (1.vcf.gz, 2.vcf.gz and so on);
#    (b) kinship matrix was already pre-computedi.

# By default, EPACTS splits your genotypes into chunks and generates single Makefile with association test instructions for each chunk.
# Then, EPACTS executes Makefile using make -j [number of cpus] (--run option in EPACTS), which runs all instructions in parallel.
# When submitting such Makefile to SLURM queue, you need to specify the number of CPUs that will be used on a single machine (since make -j can't run parallel jobs distributed across multiple machines).
# The script below submits EPACTS jobs into SLURM queue for each chromosome separately, and allocates 8 CPUs for each chromosome (4Gb per CPU).
# Thus, in total there will be 176 (22 * 8) parallel jobs.


partition=nomosix
cpus=8
mb=4000
stest=q.emmax
ped_file=
pheno_name=
kinship_matrix=

for chr in `seq 1 22`
do
  sbatch -p ${partition} -J ${chr} --ntasks=1 --cpus-per-task=${cpus} --mem-per-cpu=${mb} --wrap="epacts single -vcf ${chr}.vcf.gz \
  -ped ${ped_file} --pheno ${pheno_name} \
  -out ${chr}.${pheno_name} \
  -test ${stest} \
  -kinf ${kinship_matrix} --chr ${chr} \
  -field DS \
  --run ${cpus}" -o ${chr}.slurm.out
done
