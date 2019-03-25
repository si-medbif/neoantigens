#!/bin/bash

# Usage: 01_alignment.sh <sample_name>

# Input: FASTQ-files on the form <sample_name>_R1.fastq.gz, <sample_name>_R2.fastq.gz
# Requires: samtools v.1.7
#           docker image biocontainers/bwa

dir_fastq=PATH_TO/fastq
dir_Output=PATH_TO/results
dir_Hg38=PATH_TO/hg38bundle

mkdir -p ${dir_Output}/$1
mkdir -p ${dir_Output}/$1/{LOG,BAM}

docker run --rm -v ${dir_fastq}:/fastq -v ${dir_Hg38}:/reference biocontainers/bwa \
	bwa mem \
	-t 4 \
	-R "@RG\tID:$1\tSM:$1\tPL:Illumina\tLB:WES" \
	/reference/Homo_sapiens_assembly38.fasta.gz \
	/fastq/$1_R1.fastq.gz \
	/fastq/$1_R2.fastq.gz \
	| samtools sort -o ${dir_Output}/$1/BAM/$1_sorted.bam
