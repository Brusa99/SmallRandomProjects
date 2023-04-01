#!/bin/bash
#SBATCH --no-requeue
#SBATCH --job-name="balltree"
#SBATCH --get-user-env
#SBATCH --partition=THIN
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=02:00:00

date
pwd
hostname

module load architecture/Intel
module load conda/22.11.1

conda activate NA

python3 balltree.py

date