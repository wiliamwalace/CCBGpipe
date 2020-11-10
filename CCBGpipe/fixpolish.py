#!/usr/bin/env python3
import subprocess
import os, sys
label=sys.argv[1]
outfile=sys.argv[2]
#print ('    '+os.getcwd())
comm="grep -i 'error' nanopolish.results{0}/1/*/stderr".format(label)
print ('    '+comm)
stdout=subprocess.getoutput(comm)
#print (stdout)
if stdout=="":
    print ('    No fix is needed.')
else:
    seq=stdout.split("\n")
    #print (len(seq))
    for i in seq:
        seqout=i.split("/")[2]
        #print (seqout)
        comm='nanopolish variants --methylation-aware dcm,dam --consensus -o plished{0}.{1}.vcf -w '.format(label,seqout)+'"'+'{0}.fa'.format(seqout)+'"'+' -r reads.fastq -b reads.sorted{0}.bam -g draft.fa -t 32 --min-candidate-frequency 0.1'.format(label)
        print ('    '+comm)
        subprocess.getoutput(comm)
    comm='nanopolish vcf2fasta -g draft.fa plished{0}.*.vcf > {1}'.format(label,outfile)
    print ('    '+comm)
    subprocess.getoutput(comm)

comm='rm draft.*'
subprocess.getoutput(comm)

