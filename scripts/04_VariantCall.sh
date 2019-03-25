#!/bin/bash

dir_Output=PATH_TO/results
dir_Hg38=PATH_TO/hg38bundle
dir_GATK=PATH_TO/gatk_somatic_variant_calling

docker run --rm -v ${dir_Output}:/Output \
        -v ${dir_Hg38}:/Hg38_dir \
	-v ${dir_GATK}:/GATKtutorial \
	broadinstitute/gatk gatk --java-options "-Xmx4g" Mutect2 \
        -R /Hg38_dir/Homo_sapiens_assembly38.fasta \
        -I /Output/$1/BAM/$1_recal.bam \
        -tumor $1 \
        -pon /GATKtutorial/1000g_pon.hg38.vcf.gz \
        --germline-resource /GATKtutorial/af-only-gnomad.hg38.vcf.gz \
        --af-of-alleles-not-in-resource 0.0000025 \
        -O /Output/$1/$1_m2.vcf.gz

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

docker run --rm -v ${dir_Output}:/out \
	broadinstitute/gatk gatk \
	--java-options "-Xmx8g" FilterMutectCalls \
	-V /out/$1/$1_m2.vcf.gz \
	--contamination-table /out/$1/tumor_calculatecontamination.table \
	-O /out/$1/$1_m2_filtered.vcf.gz

