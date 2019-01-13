#!/bin/bash

dir_fastq=/home/nuttiebean/data/Fastq
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script
dir_Hg38=/home/nuttiebean/HumanGenome
dir_Resources=/home/nuttiebean/resources


docker run --rm -it -v ${dir_fastq}:/data_fastq \
	-v ${dir_Output}:/Output \
	-v ${dir_Script}:/Script \
	-v ${dir_Hg38}:/Hg38_dir \
	-v ${dir_Resources}:/Resources \
	broadinstitute/gatk3:3.8-1 gatk --java-options "-Xmx8G" \
	BaseRecalibrator \
	-R /Hg38_dir/hg38.fa \
	--known-sites /Resources/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
	--known-sites /Resources/dbsnp_146.hg38.vcf.gz \
	-I /Output/$1/BAM/$1_dedupped.bam \
	-O /Output/$1/table/$1_perform_bqsr.table

docker run --rm -it -v ${dir_fastq}:/data_fastq \
        -v ${dir_Output}:/Output \
        -v ${dir_Script}:/Script \
        -v ${dir_Hg38}:/Hg38_dir \
        -v ${dir_Resources}:/Resources \
        broadinstitute/gatk3:3.8-1 gatk --java-options "-Xmx8G" \
	ApplyBQSR \
	-R /Hg38_dir/hg38.fa \
	-I /Output/$1/BAM/$1_dedupped.bam \
	--bqsr-recal-file /Output/$1/table/$1_perform_bqsr.table \
	-O /Output/$1/table/$1_recal.bam

