#!/bin/bash

dir_fastq=/home/nuttiebean/data/Fastq
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script
dir_Hg38=/home/nuttiebean/HumanGenome
#Metrics= ??????

docker run -it -v ${dir_fastq}:/data_fastq \
	-v ${dir_Output}:/Output \
	-v ${dir_Script}:/Script \
	-v ${dir_Hg38}:/Hg38_dir \
	broadinstitute/picard:latest \
	MarkDuplicates \
	CREATE_INDEX=true \
	I=/Output/$1/BAM/$1_sorted.bam \
	O=/Output/$1/BAM/$1_dedupped.bam \
	M=/Output/$1/BAM/$1_dedup_output.metrics

#docker run --rm -it -v /home/nuttiebean/data/Fastq:/data_fastq -v /home/nuttiebean/data/Output:/Output -v /home/nuttiebean/Script:/Script -v /home/nuttiebean/HumanGenome:/Hg38_dir biocontainers/picard:v2.3.0_cv3 java -jar picard.jar MarkDuplicates CREATE_INDEX=true I=/Output/SRR7783552/BAM/SRR7783552_sorted.bam O=/Output/SRR7783552/BAM/SRR7783552_dedupped.bam


#java -jar picard.jar \
#docker run -it -v /root/data/Fastq:/data_fastq -v /root/data/Output:/Output -v /root/Script:/Script -v /root/HumanGenome:/Hg38_dir biocontainers/bwa:v0.7.15_cv3

