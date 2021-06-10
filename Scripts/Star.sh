#!/bin/bash
#
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=8:00:00 
#SBATCH --mem=64GB
#SBATCH --job-name=STAR
#SBATCH --output=STAR_%j.out
#SBATCH --error=STAR_%A_%a.err

# Load trimmomatic
module load star/2.7.7a

for r1 in *_1P.fastq.gz; 
do 
	r2=$(echo $r1|sed 's/_1P/_2P/'); 
	name=$(echo $r1|sed 's/_1P.fastq.gz//'|sed 's/Raw_Reads\///'); 
	
	STAR --readFilesCommand zcat --runMode alignReads --readFilesIn $r1 $r2 --outSAMtype BAM SortedByCoordinate --runThreadN 16 --genomeDir STAR/GENOME --outFileNamePrefix  STAR/RESULTS/$name;
	
done > STAR_Commands
