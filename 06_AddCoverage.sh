#!/bin/bash                                                                                                                                                              
set -e

# What pVACSec is looking for in the VCF file:
# Type 			: VCF sample 				: Format Fields
# Tumor DNA Coverage 	: single-sample VCF or sample_name 	: AD, DP, and AF
# Tumor RNA Coverage 	: single-sample VCF or sample_name 	: RAD, RDP, and RAF
# Normal DNA Coverage 	: --normal-sample-name 			: AD, DP, and AF

DIR_BAM=$1
DIR_VCF=$2
DIR_HG38=/gnome/genome_database/gatk_bundle/hg38bundle
SAMPLE=$3

# Creates the *readcount_snv.tsv, and *readcount_indel.tsv from RNA BAM-files.
docker run --rm -v ${DIR_BAM}:/bam \
	-v ${DIR_VCF}:/vcf \
        -v ${DIR_HG38}:/Hg38_dir \
        mgibio/bam_readcount_helper-cwl:1.0.0 \
        /usr/bin/python /usr/bin/bam_readcount_helper.py \
        /vcf/${SAMPLE}_m2_vep_filtered.vcf \
        ${SAMPLE} \
        /Hg38_dir/Homo_sapiens_assembly38.fasta \
        /bam/${SAMPLE}_Aligned.sortedByCoord.out.bam \
        /vcf/

# Add gene expression data to the vcf files
docker run --rm -v ${DIR_BAM}:/bam \
	-v ${DIR_VCF}:/vcf \
        griffithlab/vatools \
        vcf-expression-annotator \
        /vcf/${SAMPLE}_m2_vep_filtered.vcf \
        /bam/${SAMPLE}_readcounts.featurecounts.txt \
        custom \
        gene \
        --id-column gene \
        --expression-column ${SAMPLE} \
        -s ${SAMPLE}

# Add RNA read counts to the vcf files
docker run --rm -v ${DIR_VCF}:/vcf \
        vatools:v1 \
        vcf-readcount-annotator \
        /vcf/${SAMPLE}_m2_vep_filtered.gx.vcf \
        /vcf/${SAMPLE}_bam_readcount_snv.tsv \
        RNA \
        -s ${SAMPLE} \
        -t snv \
        -o /vcf/${SAMPLE}_1.vcf

docker run --rm -v ${DIR_VCF}:/vcf \
        vatools:v1 \
        vcf-readcount-annotator \
        /vcf/${SAMPLE}_1.vcf \
        /vcf/${SAMPLE}_bam_readcount_indel.tsv \
        RNA \
        -s ${SAMPLE} \
        -t indel \
        -o /vcf/${SAMPLE}_m2_vep_filtered.gx.cov.vcf
