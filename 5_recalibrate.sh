#!/bin/bash

#Recalibrate quality scores
for sample in M213 MMNK RBE;
do
	docker run --rm -v /:/data broadinstitute/gatk gatk --java-options "-Xmx8G" \
		BaseRecalibrator \
		-R /data/tiger/harald/rnaseq/ensemble_ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
		--known-sites /data/tiger/resources/hg38bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
		--known-sites /data/tiger/resources/hg38bundle/Homo_sapiens_assembly38.known_indels.vcf.gz \
		--known-sites /data/tiger/resources/hg38bundle/dbsnp_146.hg38.vcf.gz \
		-I /data/gnome/uthaiwan/output3/${sample}_splitncigar.bam \
		-O /data/gnome/uthaiwan/output3/${sample}_perform_bqsr.table 

	docker run --rm -v /:/data broadinstitute/gatk gatk --java-options "-Xmx8G" \
		ApplyBQSR \
		-R /data/tiger/harald/rnaseq/ensemble_ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
		-I /data/gnome/uthaiwan/output3/${sample}_splitncigar.bam \
		--bqsr-recal-file /data/gnome/uthaiwan/output3/${sample}_perform_bqsr.table \
		-O /data/gnome/uthaiwan/output3/${sample}_recal.bam
done
