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

for r1 in *_1P.fastq.gz; 
do 
	r2=$(echo $r1|sed 's/_1P/_2P/'); 
	name=$(echo $r1|sed 's/_1P.fastq.gz//'|sed 's/Raw_Reads\///'); 
	
	kallisto quant -i {kallisto_index} -t 16 -o kallisto $r1 $r2;
	
done > kallisto_cmds
