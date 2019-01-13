#!/bin/bash

dir_fastq=/home/nuttiebean/data/Fastq
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script
dir_Hg38=/home/nuttiebean/HumanGenome

#mkdir -p ${dir_Output}/$1 ; mkdir -p ${dir_Output}/$1/{LOG,SAM,BAM}

##Indexting
#time bwa index -a bwtsw ${dir_Hg38}/hg38.fa

##Alignment
bwa mem -t 2 -R '@RG\tID:$1\tSM:$1\tPL:Illumina\tLB:WES' ${dir_Hg38}/hg38bwaidx \
	${dir_fastq}/$1_1.fastq.gz ${dir_fastq}/$1_2.fastq.gz |samtools sort -o ${dir_Output}/$1/BAM/$1_sorted.bam
