#!/bin/bash

#Take cat sam file without header

#java -jar ~/bin/picard-tools-1.72/ReplaceSamHeader.jar I=results/aln/PE/L1208_Track-2047_hg19.sam.p HEADER=results/aln/PE/L1208_Track-2047_hg19.sam.h O=results/aln/PE/L1208_Track-2047_hg19.sam.f


x=10
for i in `eval echo {0000..$x}`
do
    temp=temp_comp/f_mapq.$i.txt
    echo $temp
    python fill_pairs.py $temp
done
