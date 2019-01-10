./vep \
	--input_file /data/1_somatic_m2.vcf.gz --output_file /data/1_somatic_m2_vep.vcf \
	--format vcf --vcf --symbol --terms SO --tsl \
	--offline --cache \
	--plugin Downstream --plugin Wildtype --force_overwrite
