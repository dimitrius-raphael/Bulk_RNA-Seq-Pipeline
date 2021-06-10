#
#SBATCH --nodes=1
#SBATCH --array=0-16
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=1 
#SBATCH --time=1:00:00 
#SBATCH --mem=64GB
#SBATCH --job-name=fastqc 
#SBATCH --output=slurm_%j.out
#SBATCH --error=arrayJob_%A_%a.err


# the below code finds all files that end with fastq.gz and saves it as an array called FILES
FILES=($(ls *fastq.gz))

# this is going to print out the name of the file -> it will be saved in our output
echo ${FILES[$SLURM_ARRAY_TASK_ID]}

# this is actually doing the work.

module load fastqc/0.11.7
fastqc ${FILES[$SLURM_ARRAY_TASK_ID]}

# I like to print this to the output so i know the script completed successfully.
echo "done"
