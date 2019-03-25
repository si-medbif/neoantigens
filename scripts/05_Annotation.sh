#!/bin/bash
dir_Reference=PATH_TO/hg38bundle
dir_Output=PATH_TO/results
docker run --rm -v ${dir_Reference}:/Reference -v ${dir_Output}:/Output vep:v2 ./vep \
	--input_file /Output/$1/$1_m2_filtered.vcf.gz \
	--output_file /Output/$1/$1_m2_vep.vcf \
	--format vcf --vcf --symbol --terms SO --tsl --hgvs \
	--fasta /Reference/Homo_sapiens_assembly38.fasta \
	--offline --cache \
	--plugin Downstream --plugin Wildtype --force_overwrite
./filter_annotated_vcf.py $1/$1_m2_vep.vcf $1/$1_m2_vep_filtered.vcf
