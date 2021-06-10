rule allout:
        input:
	        forward_paired = "samples/trimmed/{filename}_forward_paired.fq.gz",
			forward_unpaired = "samples/trimmed/{filename}_forward_unpaired.fq.gz",
			reverse_paired = "samples/trimmed/{filename}_reverse_paired.fq.gz",
			reverse_unpaired = "samples/trimmed/{filename}_reverse_unpaired.fq.gz"
			"samples/FASTQC/{filename}{filename2}_fastqc.zip"
	        "preprocessing/STAR/{filename}Log.final.out",

	        "preprocessing/STAR/{filename}Log.out",

	        "preprocessing/STAR/{filename}Log.progress.out",

	        "preprocessing/STAR/{filename}SJ.out.tab",

	        directory("preprocessing/STAR/{filename}_STARtmp"),
			"preprocessing/STAR/{filename}Aligned.sortedByCoord.out.bam"
			"multiqc_report_new.html"
			"analysis/{filename}/kallisto/abundance.tsv"
			"analysis/Counts.csv"
			
#rule trim:
    #input:
      #forward="samples/{filename}__R1.fastq.gz",
      #reverse="samples/{filename}__R2.fastq.gz"
    #output:
      #forward_paired = "samples/trimmed/{filename}_forward_paired.fq.gz",
      #forward_unpaired = "samples/trimmed/{filename}_forward_unpaired.fq.gz",
      #reverse_paired = "samples/trimmed/{filename}_reverse_paired.fq.gz",
      #reverse_unpaired = "samples/trimmed/{filename}_reverse_unpaired.fq.gz"
 
    #threads:16
 
    #shell:
      #"""trimmomatic PE -phred33 -threads {threads} {input.forward} {input.reverse} {output.forward_paired} \
      #{output.forward_unpaired} {output.reverse_paired} {output.reverse_unpaired} \
      #ILLUMINACLIP:/projectnb/bubhub/conda_root/user_conda/ikjotsdh/Trimmomatic-0.38/adapters/TruSeq3-PE-2.fa:2:30:10 \
      #LEADING:3 \
      #TRAILING:3 \
      #SLIDINGWINDOW:4:15 \
      #MINLEN:36"""
 
 
rule fastqc:
    input:
        "samples/trimmed/{filename}{filename2}.fq.gz",
    output:
        "samples/FASTQC/{filename}{filename2}_fastqc.zip"
    threads:16
    shell:
        "fastqc -o samples/FASTQC {input} -threads {threads}"
 
rule STAR:
    input:
        FP="samples/trimmed/{filename}_forward_paired.fq.gz",
        RP="samples/trimmed/{filename}_reverse_paired.fq.gz"
    output:
        "preprocessing/STAR/{filename}Log.final.out",
        "preprocessing/STAR/{filename}Log.out",
        "preprocessing/STAR/{filename}Log.progress.out",
        "preprocessing/STAR/{filename}SJ.out.tab",
        directory("preprocessing/STAR/{filename}_STARtmp"),
        "preprocessing/STAR/{filename}Aligned.sortedByCoord.out.bam"
    threads:16
    shell:
        "STAR --readFilesCommand zcat --runMode alignReads --readFilesIn {input.FP} {input.RP} --outSAMtype BAM SortedByCoordinate --runThreadN {threads} --genomeDir {star_index} --outFileNamePrefix  preprocessing/STAR/{wildcards.filename}"
 
rule multiqc:
    input:
        expand("samples/FASTQC/{filename}{filename2}_fastqc.zip",filename=files,filename2=['_forward_paired','_forward_unpaired','_reverse_paired','_reverse_unpaired']),
        expand("preprocessing/STAR/{filename}Log.final.out",filename=files)
    output:
        "multiqc_report_new.html"
    shell:
        '''
        export LC_ALL=en_US.utf8
        export LANG=$LC_ALL
        multiqc samples/FASTQC/ preprocessing/STAR/ -n {output}
        '''
 
rule kallisto:
    input:
        S1="samples/trimmed/{filename}_forward_paired.fq.gz",
        S2="samples/trimmed/{filename}_reverse_paired.fq.gz"
    threads:16
    params:
        dir="analysis/{filename}/kallisto"
    output:
        "analysis/{filename}/kallisto/abundance.tsv"
    shell:
        "kallisto quant -i {kallisto_index} -t {threads} -o {params.dir} {input.S1} {input.S2}"
 
rule csvgather:
    input:
        expand("analysis/{filename}/kallisto/abundance.tsv",filename=files)
    output:
        "analysis/Counts.csv"
    shell:
        'csvgather -d "," -j 0 -f est_counts -t "s:est_counts:{{dir}}:" -t "s:__kallisto_counts::" -t "s:analysis/::" -t "s:/kallisto::" {input} -o {output}'
rule gene_counts:
    input:
        "analysis/Counts.csv"
    output:
        "analysis/Gene_counts.csv"
    run:
 
            import csv
            f=open('analysis/Counts.csv','r')
            csv_f = csv.reader(f, delimiter=',')
            gene_list=dict()
            heading=next(csv_f)
            for row in csv_f:
                first=row[0].split('|')
                #print(first)
                gene=first[1]
                #print(gene)
                values=[float(num) for num in row[1:]]
                #print(values)
                if gene in gene_list.keys():
                    for i in range(len(values)):
                        gene_list[gene][i] += values[i]
                else:
                    gene_list[gene] = values
            f.close
            with open('analysis/Gene_counts.csv','w') as x:
                writer=csv.writer(x,dialect='excel')
                writer.writerow(heading)
                for gene in sorted(gene_list.keys()):
                    row=[gene]+gene_list[gene]
                    writer.writerow(row)
