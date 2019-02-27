#!/bin/bash

dir_fastq=/root/data/Fastq
dir_Output=/root/data/Output
dir_Script=/root/Script
dir_Hg38=/root/HumanGenome

docker run -it -v ${dir_fastq}:/data_fastq \
	-v ${dir_Output}:/Output \
	-v ${dir_Script}:/Script \
	-v ${dir_Hg38}:/Hg38_dir \
	biocontainers/picard:v2.3.0_cv3 \
	java -jar picard.jar \
	I=/Output/$1/SAM/$1.sam \
	O=/Output/$1/BAM/$1_sorted.bam \
	SORT_ORDER=coordinate


#docker run -it -v /root/data/Fastq:/data_fastq -v /root/data/Output:/Output -v /root/Script:/Script -v /root/HumanGenome:/Hg38_dir biocontainers/bwa:v0.7.15_cv3


