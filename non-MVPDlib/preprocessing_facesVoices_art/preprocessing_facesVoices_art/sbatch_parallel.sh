#!/bin/bash
#SBATCH --job-name=facesVoices_parallel
#SBATCH --nodes=1 --cpus-per-task=1  --tasks-per-node=11
#SBATCH --mem-per-cpu=10GB
#SBATCH --mail-user=anzellot@mit.edu --mail-type=ALL
#SBATCH --output=../sbatchrunEIB_stdout_%j.txt
#SBATCH --error=../sbatchrunEIB_stderr_%j.txt

module add openmpi/gcc/64/1.8.1
module add mit/matlab/2015a
cd /mindhive/saxelab3/anzellotti/facesVoices_art2/preprocessing_facesVoices_art

chmod +x sbatch_single.sh
mpiexec -n 11 ./sbatch_single.sh
