#!/bin/bash

dir_Output=PATH_TO/results
dir_Hg38=PATH_TO/hg38bundle


docker run --rm -it -v ${dir_Output}:/Output \
	-v ${dir_Hg38}:/Hg38_dir \
	broadinstitute/gatk:4.0.2.1 gatk --java-options "-Xmx8G" \
	BaseRecalibrator \
	-R /Hg38_dir/Homo_sapiens_assembly38.fasta \
	--known-sites /Hg38_dir/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
	--known-sites /Hg38_dir/dbsnp_146.hg38.vcf.gz \
	-I /Output/$1/BAM/$1_dedupped.bam \
	-O /Output/$1/BAM/$1_perform_bqsr.table

docker run --rm -it -v ${dir_Output}:/Output \
        -v ${dir_Hg38}:/Hg38_dir \
        broadinstitute/gatk:4.0.2.1 gatk --java-options "-Xmx8G" \
	ApplyBQSR \
	-R /Hg38_dir/Homo_sapiens_assembly38.fasta \
	-I /Output/$1/BAM/$1_dedupped.bam \
	--bqsr-recal-file /Output/$1/BAM/$1_perform_bqsr.table \
	-O /Output/$1/BAM/$1_recal.bam

dir_GATK=PATH_TO/gatk_somatic_variant_calling

docker run --rm -v ${dir_GATK}:/data -v ${dir_Output}:/out \
	broadinstitute/gatk gatk \
	--java-options "-Xmx8g" GetPileupSummaries \
	-I /out/$1/BAM/$1_recal.bam \
	-V /data/small_exac_common_3.hg38.vcf.gz \
	-O /out/$1/tumor_getpileupsummaries.table

docker run --rm -v ${dir_GATK}:/data -v ${dir_Output}:/out \
	broadinstitute/gatk gatk \
	--java-options "-Xmx8g" CalculateContamination \
	-I /out/$1/tumor_getpileupsummaries.table \
	-O /out/$1/tumor_calculatecontamination.table

