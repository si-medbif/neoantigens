#!/bin/bash

dir_Output=PATH_TO/results

docker run --rm -it -v ${dir_Output}:/Output \
	broadinstitute/picard:latest \
	MarkDuplicates \
	CREATE_INDEX=true \
	I=/Output/$1/BAM/$1_sorted.bam \
	O=/Output/$1/BAM/$1_dedupped.bam \
	M=/Output/$1/BAM/$1_dedup_output.metrics




