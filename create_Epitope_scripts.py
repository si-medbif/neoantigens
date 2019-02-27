#!/usr/bin/env python
# Combines the HLA alleles from a file "{sample}.results" to the
# script template file "06_Pvac.sh.template" to create the final
# script file "06_pvac_{sample}.sh"

import sys

sample = sys.argv[1]
input_file = '06_Pvac.sh.template'
HLA_file = '{}.result'.format(sample)
script_file = '06_Pvac_{}.sh'.format(sample)

hla = []
with open(HLA_file, 'r') as fin:
    for line in fin:
        l = line.strip().split()
        try:
            allele = l[0]
        except IndexError:
            continue
        if allele[:2] in ['A*','B*','C*']:
            allele = 'HLA-' + allele
        t = ':'.join(allele.split(':')[:2])
        if t not in hla:
            hla.append(t)

with open(input_file, 'r') as fin, open(script_file, 'w') as fout:
    for line in fin:
        if line.startswith'#HLA=':
            fout.write('HLA={}\n'.format(','.join(hla)))
        elif line.startswith('#Abnm_ID='):
            fout.write('Abnm_ID={}\n'.format(sample))
        else:
            fout.write(line[1:])
