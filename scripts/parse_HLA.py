#!/usr/bin/env python

import pandas as pd
import numpy as np
import re
from operator import itemgetter
from collections import Counter

#############KOURAMI##############
def kourami(infile):
    db = {}
    with open(infile, 'r') as fin:
        for line in fin:
            l = line.strip().split()
            try:
                allele = l[0]
            except IndexError:
                continue
            gene = re.search('[^*]+',allele).group(0)
            fields = re.search('..:[^:]+',allele).group(0)
            if gene in ['A','B','C']:
                gene = 'HLA-' + gene
            if gene not in db:
                db[gene] = {0:'',1:'',2:[]}
            if ';' in allele:
                for al in allele.split(';'):
                    gene = re.search('[^*]+',al).group(0)
                    if gene in ['A','B','C']:
                        gene = 'HLA-' + gene
                    fields = re.search('..:[^:]+',al).group(0)
                    db[gene][2].append(fields)
            elif db[gene][0] == '':
                db[gene][0] = fields
            else:
                db[gene][1] = fields
    return db

##############PHLAT##############
def phlat(infile):
    db = {}
    with open(infile, 'r') as fin:
        for line in fin:
            l = line.strip().split()
            if l[0] == 'Locus':
                continue
            try:
                allele_1 = l[1]
                allele_2 = l[2]
            except IndexError:
                continue
            gene = re.search('[^*]+',allele_1).group(0)
            if gene in ['A','B','C']:
                gene = 'HLA-' + gene
            if gene not in db:
                db[gene] = {0:'',1:''}
            fields = re.search('..:[^:]+',allele_1).group(0)
            db[gene][0] = fields
            fields = re.search('..:[^:]+',allele_2).group(0)
            db[gene][1] = fields
    return db

##############HLAHD##############
def hlahd(infile):
    db = {}
    with open(infile, 'r') as fin:
        for line in fin:
            l = line.strip().split('\t')
            try:
                gene = l[0]
                alleles = l[1:]
            except IndexError:
                continue
            if gene not in ['A','B','C','DQA1','DQB1','DRB1']:
                continue
            if gene in ['A','B','C']:
                gene = 'HLA-' + gene
            if gene not in db:
                db[gene] = {0:'',1:'', 2:[]}
            if len(alleles) > 2:
                first, second = [],[]
                for ind, allele in enumerate(alleles):
                    if ind % 2 == 0:
                        first.append(allele)
                    else:
                        second.append(allele)
                fir = Counter(first).most_common()[0]
                sec = Counter(second).most_common()[0]
                if fir[1] > len(first) // 2:
                    try:
                        fields = re.search('..:[^:]+',fir[0]).group(0)
                    except AttributeError:
                        fields = ''
                    db[gene][0] = fields
                    if sec[1] > len(second)//2:
                        try:
                            fields = re.search('..:[^:]+',sec[0]).group(0)
                        except AttributeError:
                            fields = ''
                        db[gene][1] = fields
                    else:
                        for secon in second:
                            try:
                                fields = re.search('..:[^:]+',secon).group(0)
                            except AttributeError:
                                fields = ''
                            db[gene][2].append(fields)
                else:
                    for al in alleles:
                        try:
                            fields = re.search('..:[^:]+',al).group(0)
                        except AttributeError:
                            fields = ''
                        db[gene][2].append(fields)
            else:
                try:
                    fields = re.search('..:[^:]+',alleles[0]).group(0)
                except AttributeError:
                    fields = ''
                db[gene][0] = fields
                try:
                    fields = re.search('..:[^:]+',alleles[1]).group(0)
                except AttributeError:
                    fields = ''
                db[gene][1] = fields
    return db

def combine(algo):
    """ algo is a list of algorithm outputs, i.e. lists of the predicted alleles from each software  """
    alleles = set([a for li in algo for a in li])
    res = []
    for allele in alleles:
        if allele == '':
            continue
        count1, count2 = 0, 0
        for group in algo:
            temp = group.count(allele)
            if temp > 0:
                count1 += 1
            if temp > 1:
                count2 += 1
        res.append([allele,count1])
        res.append([allele,count2])
    res = sorted(res, key=itemgetter(1), reverse=True)
    if len(res) == 0 or res[0][1] <= len(algo) // 2: # No data, or no agreement
        first, second = 'NaN','NaN'
        return first, second
    first = res[0][0]
    if res[1][1] <= len(algo) // 2: # Only first allele has an agreement
        second = 'NaN'
    else:
        second = res[1][0]
    return first,second

x1, x2, x3, x4, x5 = [], [], [], [], []
outfile = '/home/harald/projects/somatic/test_samples/hla_alleles/HLA_alleles_prediction.txt'
with open(outfile, 'w') as fout:
    for index in range(34,93):
        sample = 'BTN-0{}'.format(index)
        genes = ['HLA-A','HLA-B','HLA-C','DQA1','DQB1','DRB1']
        infile = '/home/harald/projects/somatic/test_samples/hla_alleles/BTN-0{}.result'.format(index)
        try:
            ko = kourami(infile)
        except FileNotFoundError:
            continue
        infile = '/home/harald/projects/somatic/test_samples/hla_alleles/BTN_0{}_PHLAT_final.result.txt'.format(index)
        ph = phlat(infile)
        infile = '/home/harald/projects/somatic/test_samples/hla_alleles/BTN_0{}_HLAHD_final.result.txt'.format(index)
        hl = hlahd(infile)
        for gene in genes:
            try:
                k1, k2, ke = ko[gene][0], ko[gene][1], ko[gene][2]
            except KeyError:
                k1, k2, ke = '','',[]
            try:
                p1, p2 = ph[gene][0], ph[gene][1]
            except KeyError:
                p1, p2 = '', ''
            try:
                h1, h2, he = hl[gene][0], hl[gene][1], hl[gene][2]
            except KeyError:
                h1, h2, he = '', '', []
            first, second = combine([[k1, k2]+ke, [p1, p2], [h1, h2]+he])
            source = [k1,k2]+ke+[p1,p2]+[h1,h2]+he
            extra = [element for element in source if element != '' and element != first]
            if first != 'NaN':
                first = gene + '*' + first
            if second != 'NaN':
                second = gene + '*' + second
            if first == 'NaN' or second == 'NaN':
                fout.write('{}\t{}\t{}\t[{}]\n'.format(sample,first,second,';'.join(extra)))
            else:
                fout.write('{}\t{}\t{}\n'.format(sample,first,second))
            
