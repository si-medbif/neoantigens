#!/usr/bin/env python
# Combines the HLA alleles from a file "{sample}.results" to the
# script template file "06_Pvac.sh.template" to create the final
# script file "06_pvac_{sample}.sh"

import sys
from collections import Counter

#sample=BTN-034

sample = sys.argv[1]
input_file = sys.argv[2] # script template
HLA_file_kourami = sys.argv[3]
HLA_file_phlat = sys.argv[4]
HLA_file_hlahd = sys.argv[5]
script_file = '06_Pvac_{}.sh'.format(sample)

#HLA LIST
hla_kourami = []
hla_phlat = []
hla_hlahd = []
hla_ALL = []

#############KOURAMI##############
with open(HLA_file_kourami, 'r') as fin:
    for line in fin:
        l = line.strip().split()
        try:
            allele = l[0]
        except IndexError:
            continue
        if ';' in allele:
            continue
        if allele[:2] in ['A*','B*','C*']:
            hla_result = allele.split(':')
            t = 'HLA-' + hla_result[0]+':' + hla_result[1]
            if t not in hla_kourami:
                hla_kourami.append(t)
            hla_ALL.append(t)
        elif allele[:5] in ['DRB1*','DQA1*','DQB1*']:
            hla_result = allele.split(':')
            t = hla_result[0]+ ':' + hla_result[1]
            if t not in hla_kourami:
                hla_kourami.append(t)
            hla_ALL.append(t)

#print('kourami=', hla_kourami)

##############PHLAT##############

with open(HLA_file_phlat, 'r') as fin:
    for line in fin:
        l = line.strip().split()
        try:
            allele_1 = l[1]
            allele_2 = l[2]
        except IndexError:
            continue
        if allele_1[:2] in ['A*','B*','C*']:
            hla_result_1 = allele_1.split(':')
            t_1 = 'HLA-' + hla_result_1[0]+':' + hla_result_1[1]
            if t_1 not in hla_phlat:
                hla_phlat.append(t_1)
            hla_ALL.append(t_1)
            hla_result_2 = allele_2.split(':')
            t_2 = 'HLA-' + hla_result_2[0]+':' + hla_result_2[1]
            if t_2 not in hla_phlat:
                hla_phlat.append(t_2)
            hla_ALL.append(t_2)
        elif allele_1[:5] in ['DRB1*','DQA1*','DQB1*']:
            hla_result_1 = allele_1.split(':')
            t_1 = hla_result_1[0] +':'+ hla_result_1[1]
            if t_1 not in hla_phlat:
                hla_phlat.append(t_1)
            hla_ALL.append(t_1)
            hla_result_2 = allele_2.split(':')
            t_2 = hla_result_2[0] +':'+ hla_result_2[1]
            if t_2 not in hla_phlat:
                hla_phlat.append(t_2)
            hla_ALL.append(t_2)

#print('phlat=', hla_phlat)

##############HLAHD##############

with open(HLA_file_hlahd, 'r') as fin:
    for line in fin:
        l = line.strip().split()
        try:
            allele_0 = l[0]
            allele_1 = l[1]
            allele_2 = l[2]
        except IndexError:
            continue
        if allele_0 in ['A','B','C']:
            hla_result_1 = allele_1.split(':')
            t_1 = (hla_result_1[0])+':' + hla_result_1[1]
            if t_1 not in hla_hlahd:
                hla_hlahd.append(t_1)
            hla_ALL.append(t_1)
            hla_result_2 = allele_2.split(':')
            t_2 = (hla_result_2[0])+':' + hla_result_2[1]
            if t_2 not in hla_hlahd:
                hla_hlahd.append(t_2)
            hla_ALL.append(t_2)
        elif allele_0 in ['DRB1','DQA1','DQB1']:
            hla_result_1 = allele_1.split(':')
            t_1 = (hla_result_1[0])[4:]+':' + hla_result_1[1]
            if t_1 not in hla_hlahd:
                hla_hlahd.append(t_1)
            hla_ALL.append(t_1)
            hla_result_2 = allele_2.split(':')
            t_2 = (hla_result_2[0])[4:]+':' + hla_result_2[1]
            if t_2 not in hla_hlahd:
                hla_hlahd.append(t_2)
            hla_ALL.append(t_2)

#print('hlahd=', hla_hlahd)
#print('all=', hla_ALL)
Dict_ALL = (dict((x,hla_ALL.count(x)) for x in set(hla_ALL)))
#print(Dict_ALL)

A = []
B = []
C = []
DQB1 = []
DQA1 = []
DRB1 = []

for i in hla_ALL:
    hla_class = i.split('*')[0]
    if hla_class == "HLA-A":
        A.append(i)
    elif hla_class == "HLA-B":
        B.append(i)
    elif hla_class == "HLA-C":
        C.append(i)
    elif hla_class == "DQB1":
        DQB1.append(i)
    elif hla_class == "DQA1":
        DQA1.append(i)
    elif hla_class == "DRB1":
        DRB1.append(i)

Dict_A = (dict((x,A.count(x)) for x in set(A)))
Dict_B = (dict((x,B.count(x)) for x in set(B)))
Dict_C = (dict((x,C.count(x)) for x in set(C)))
Dict_DQB1 = (dict((x,DQB1.count(x)) for x in set(DQB1)))
Dict_DQA1 = (dict((x,DQA1.count(x)) for x in set(DQA1)))
Dict_DRB1 = (dict((x,DRB1.count(x)) for x in set(DRB1)))

SD_A = sorted(Dict_A.items(), key=lambda kv: kv[1], reverse=True)
SD_B = sorted(Dict_B.items(), key=lambda kv: kv[1], reverse=True)
SD_C = sorted(Dict_C.items(), key=lambda kv: kv[1], reverse=True)
SD_DQB1 = sorted(Dict_DQB1.items(), key=lambda kv: kv[1], reverse=True)
SD_DQA1 = sorted(Dict_DQA1.items(), key=lambda kv: kv[1], reverse=True)
SD_DRB1 = sorted(Dict_DRB1.items(), key=lambda kv: kv[1], reverse=True)

LIST_ALL=[]

for hla_class in [SD_A, SD_B, SD_C, SD_DQB1, SD_DQA1, SD_DRB1]:
    N = len(hla_class)
    if (hla_class)[0][1] >= 5: # 11 11 12
        LIST_ALL.append(hla_class[0][0])
    elif (hla_class)[0][1] == 4: # 11 12 12 or 11 12 13
        LIST_ALL.append(hla_class[0][0])
        if (hla_class)[1][1] == 2:
            LIST_ALL.append(hla_class[1][0])
    elif (hla_class)[0][1] == 3:
        if (hla_class)[1][1] == 3 or (hla_class)[1][1] == 2:
            LIST_ALL.append(hla_class[0][0])
            LIST_ALL.append(hla_class[1][0])
        else:
            for each in range(N) :
                LIST_ALL.append(hla_class[each-1][0])

print(LIST_ALL)

with open(input_file, 'r') as fin, open(script_file, 'w') as fout:
    for line in fin:
        if line.startswith('#HLA='):
            fout.write('HLA={}\n'.format(','.join(LIST_ALL)))
        elif line.startswith('#Abnm_ID='):
            fout.write('Abnm_ID={}\n'.format(sample))
        else:
            fout.write(line[1:])
