#!/bin/bash

#https://gatkforums.broadinstitute.org/gatk/discussion/1601/how-can-i-prepare-a-fasta-file-to-use-as-reference

dir_fastq=/home/nuttiebean/data/Fastq
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script
dir_Hg38=/home/nuttiebean/HumanGenome
#Metrics= ??????

#Creating the fasta sequence dictionary file
docker run -it -v ${dir_fastq}:/data_fastq \
        -v ${dir_Output}:/Output \
        -v ${dir_Script}:/Script \
        -v ${dir_Hg38}:/Hg38_dir \
        broadinstitute/picard:latest \
        CreateSequenceDictionary \
	R= /Hg38_dir/hg38.fa \
	O= /Hg38_dir/hg38.dict

#Creating the fasta index file

samtools faidx ${dir_Hg38}/hg38.fa
