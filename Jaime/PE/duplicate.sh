#!/bin/bash

FILE=$1
#Annovar
#awk 'BEGIN { FS="\t"; OFS="\t" }  { $1=substr($1,4) ; $2=$2 "\t" $2} 1' < results/snp_calls/PE/$FILE > results/snp_calls/PE/$FILE.d

#perl ~/bin/annovar/annotate_variation.pl --buildver hg19 --hgvs \
#--outfile results/snp_calls/PE/$FILE.d.anno results/snp_calls/PE/$FILE.d ~/bin/annovar/humandb/

#SnpEff

awk 'BEGIN { FS="\t"; OFS="\t" }   { $1=substr($1,4)} 1' < results/snp_calls/PE/$FILE > results/snp_calls/PE/$FILE.e
java -jar ~/bin/snpEff_3_0/snpEff.jar eff -c ~/bin/snpEff_3_0/snpEff.config  hg19 -s results/snp_calls/PE/$FILE.stat -i txt -o txt results/snp_calls/PE/$FILE.e > results/snp_calls/PE/$FILE.eff
rm results/snp_calls/PE/$FILE.e
