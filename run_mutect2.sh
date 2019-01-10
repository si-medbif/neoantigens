docker run --rm -v $PWD:/data broadinstitute/gatk gatk --java-options "-Xmx4g" Mutect2 \
	-R /data/Homo_sapiens_assembly38.fasta \
	-I /data/somatic-hg38_hcc1143_T_clean.bam \
	-I /data/somatic-hg38_hcc1143_N_clean.bam \
	-tumor HCC1143_tumor \
	-normal HCC1143_normal \
	-pon /data/1000g_pon.hg38.vcf.gz \
	--germline-resource /data/somatic-hg38_af-only-gnomad.hg38.vcf.gz \
	--af-of-alleles-not-in-resource 0.0000025 \
	--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
	-O /data/1_somatic_m2.vcf.gz \
