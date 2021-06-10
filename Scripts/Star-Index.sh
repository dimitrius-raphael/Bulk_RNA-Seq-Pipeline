#!/bin/bash
#
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=6:00:00 
#SBATCH --mem=64GB
#SBATCH --job-name=STAR_index
#SBATCH --output=star_index_%j.out
#SBATCH --error=star_index_%A_%a.err


#Be sure to change output prefix and file names to reflect appropriate species

# Load STAR
module load star/2.7.7a

STAR --runThreadN 6 \
--runMode genomeGenerate \
--genomeDir GENOME \
--genomeFastaFiles GENOME/Mus_musculus.GRCm39.dna.primary_assembly.fa \
--sjdbGTFfile GENOME/Mus_musculus.GRCm39.104.gtf \
--sjdbOverhang 49
