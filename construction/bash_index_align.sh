#!/bin/bash

time bwa index -a bwtsw /root/HumanGenome/hg38.fa

#time bwa mem -t 2 -R'@RG\tID:SRR7783552\tSM:SRR7783552\tPL:Illumina\tLB:WES' /root/data/Fastq/hg38.fa /root/data/Fastq/SRR7783552_1.fastq.gz /root/data/Fastq/SRR7783552_2.fastq.gz > /root/data/Output/SRR7783552/SAM/SRR7783552.sam 2>&1| tee log_align.log


