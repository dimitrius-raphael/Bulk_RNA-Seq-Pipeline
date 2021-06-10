#!/bin/bash
#
#SBATCH --nodes=1
#SBATCH --array=0-16
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=1:00:00 
#SBATCH --mem=64GB
#SBATCH --job-name=trimmomatic 
#SBATCH --output=trim_%j.out
#SBATCH --error=trim_%A_%a.err

# Load trimmomatic
module load trimmomatic

for f in $(ls *.fastq.gz | sed 's/?_001.fastq.gz//' | sort -u)
do
java -jar Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 -threads 16 ${f}1_001.fastq.gz ${f}1_002.fastq.gz  ${f}_R1_paired.fq.gz ${f}1_unpaired.fq.gz ${f}_2_paired.fq.gz ${f}2_unpaired.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
