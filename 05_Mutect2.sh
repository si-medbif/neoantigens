#!/bin/bash

dir_fastq=/home/nuttiebean/data/Fastq
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script
dir_Hg38=/home/nuttiebean/HumanGenome
dir_Resources=/home/nuttiebean/resources
dir_Harald_GATK=/home/harald/gatk_tutorial

docker run --rm -v -v ${dir_fastq}:/data_fastq \
        -v ${dir_Output}:/Output \
        -v ${dir_Script}:/Script \
        -v ${dir_Hg38}:/Hg38_dir \
        -v ${dir_Resources}:/Resources \
	-v ${dir_Harald_GATK}:/Harald \
	broadinstitute/gatk gatk --java-options "-Xmx4g" Mutect2 \
        -R /Harald/Homo_sapiens_assembly38.fasta \
        -I /Output/$1/table/$1_recal.bam \
        -I /Output/$2/table/$2_recal.bam \
        -tumor $1 \
        -normal $2 \
        -pon /Harald/1000g_pon.hg38.vcf.gz \
        --germline-resource /Harald/somatic-hg38_af-only-gnomad.hg38.vcf.gz \
        --af-of-alleles-not-in-resource 0.0000025 \
        --disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
        -O /Output/$1/$1_m2.vcf.gz \

