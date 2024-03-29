#!/bin/bash

# Usage: 05_Annotation.sh <output-folder> <sample_name>

# Input: VCF file, somatic mutations
# Output: VCF file, somatic mutations, annotated by VEP software package

# Required: vep docker image (see instructions in configure_vep.txt)
# Output folder require write permissions to be set for all

DIR_REFERENCE=/gnome/genome_database/gatk_bundle/hg38bundle
DIR_VCF=$1
SAMPLE=$2
DIR=$(dirname "${BASH_SOURCE[0]}")

docker run --rm -v ${DIR_REFERENCE}:/Reference \
	-v ${DIR_VCF}:/Output \
	vep:v1 ./vep \
	--input_file /Output/${SAMPLE}_m2_filtered.vcf.gz \
	--output_file /Output/${SAMPLE}_m2_vep.vcf \
	--format vcf --vcf --symbol --terms SO --tsl --hgvs \
	--protein --sift b --polyphen b \
	--af --af_gnomad \
	--fasta /Reference/Homo_sapiens_assembly38.fasta \
	--offline --cache \
	--plugin Downstream --plugin Wildtype --force_overwrite

${DIR}/filter_annotated_vcf.py \
	${DIR_VCF}/${SAMPLE}_m2_vep.vcf \
	${DIR_VCF}/${SAMPLE}_m2_vep_filtered.vcf
