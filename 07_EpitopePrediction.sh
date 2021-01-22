#!/bin/bash

# Usage: 06_EpitopePrediction.sh <output-folder> <sample-name> <HLA-alleles>
# HLA-alleles are provided as a comma-separated list of 4-digit alleles: 
#   HLA-A*24:02,HLA-B*54:01,HLA-C*03:02,DQA1*01:01,DQB1*05:03,DRB1*03:01
# There is no limit to the number of alleles that can be provided,
# although runtime will increase.

DIR_VCF=$1
DIR_PVAC=$2
SAMPLE=$3
HLA=$4

docker run --rm -v ${DIR_VCF}:/vcf \
       -v ${DIR_PVAC}:/pvac \
       griffithlab/pvactools:1.5.4 \
	pvacseq run \
       /vcf/${SAMPLE}_m2_vep_filtered.vcf \
       -t 4 \
       --iedb-install-directory /opt/iedb \
	${SAMPLE} \
	${HLA} \
	MHCflurry MHCnuggetsI MHCnuggetsII NNalign NetMHC PickPocket SMM SMMPMBEC SMMalign \
	/pvac/ \
       -e 8,9,10,11,12
