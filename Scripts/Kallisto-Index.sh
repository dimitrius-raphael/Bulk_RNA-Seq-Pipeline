#!/bin/bash
#
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=16:00:00 
#SBATCH --mem=64GB
#SBATCH --job-name=kallisto
#SBATCH --output=kallisto_%j.out
#SBATCH --error=kallisto_%A_%a.err

# Load kallisto
module load kallisto/0.44.0

#Be Sure to change file name and output prefix for appropriate organism

kallisto index --index="Mus_musculus.GRCm39_index" kallisto/kallisto_index/Mus_musculus.GRCm39.cdna.all.fa.gz
