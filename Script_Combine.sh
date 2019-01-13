#!/bin/bash

SampleID=$1
dir_Output=/home/nuttiebean/data/Output
dir_Script=/home/nuttiebean/Script

#mkdir -p ${dir_Output}/$1 ; mkdir -p ${dir_Output}/$1/{LOG,SAM,BAM,table}

#time bash ${dir_Script}/01_BWA_Alignment_directly.sh ${SampleID} 2>&1| tee ${dir_Output}/${SampleID}/LOG/Aligment.log

##time bash /home/nuttiebean/Script/02_SortSam.sh ${SampleID} 2>&1| tee ${dir_Output}/$1/LOG/SortSam.log
##rm ${dir_Output}/${SampleID}/SAM/*

#time bash ${dir_Script}/03_MarkDuplicate.sh ${SampleID} 2>&1| tee ${dir_Output}/${SampleID}/LOG/Markduplicate.log
time bash ${dir_Script}/04_Recalibration.sh ${SampleID} 2>&1| tee ${dir_Output}/${SampleID}/LOG/Recalibration.log
