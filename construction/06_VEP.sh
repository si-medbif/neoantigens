./vep \
	--input_file /Output/$1/$1_m2.vcf.gz --output_file /Output/$1/$1_m2_vep.vcf \
	--format vcf --vcf --symbol --terms SO --tsl \
	--offline --cache \
	--plugin Downstream --plugin Wildtype --force_overwrite
