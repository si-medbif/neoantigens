#!/bin/bash

dir_fastq=PATH_TO/fastq
dir_Output=PATH_TO/results
dir_Hg38=PATH_TO/hg38bundle

mkdir -p ${dir_Output}/$1
mkdir -p ${dir_Output}/$1/{LOG,BAM}

docker run --rm -v ${dir_fastq}:/fastq -v ${dir_Hg38}:/reference biocontainers/bwa \
	bwa mem \
	-t 16 \
	-R "@RG\tID:$1\tSM:$1\tPL:Illumina\tLB:WES" \
	/reference/Homo_sapiens_assembly38.fasta.gz \
	/fastq/$1_Sample_$2/$2_combined_R1.fastq.gz \
	/fastq/$1_Sample_$2/$2_combined_R2.fastq.gz \
	| samtools sort -o ${dir_Output}/$1/BAM/$1_sorted.bam
