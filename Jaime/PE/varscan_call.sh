#!/bin/bash
#
# Author: Sean Davis <seandavi@gmail.com>
#
# Uses named pipes (FIFO) to reduce storage needs
# to call varscan somatic
# Some details may need to be edited to meet particular needs
# call with the following parameters
# 1) The FASTA file containing the reference genome
# 2) The Normal bam file
# 3) The tumor bam file
# 4) The output file prefix
# Outputs the varscan snp and indel files as well as the
# somatic-processed files

REFFILE=$1
TUMORBAM=$3
NORMALBAM=$2
OUTFILE=$4
PRE_REF=$5


echo Name of the files to read: ${TUMORBAM} ${NORMALBAM}
echo Name of the genome ref to use: ${REFFILE}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${OUTFILE}


mkdir -p scratch/sedavis

mkfifo scratch/sedavis/${TUMORBAM}.fifo
mkfifo scratch/sedavis/${NORMALBAM}.fifo


samtools mpileup -f genome/human/$REFFILE -q 30 -C 50  -P Illumina -B -L 10000 -d 10000 \
 results/aln/PE/${TUMORBAM}_${PRE_REF}.b.recal.bam > scratch/sedavis/${TUMORBAM}.fifo & 
echo uno &
samtools mpileup -f genome/human/$REFFILE -q 30 -C 50  -P Illumina -B -L 10000 -d 10000 \
 results/aln/PE/${NORMALBAM}_${PRE_REF}.b.recal.bam  > scratch/sedavis/${NORMALBAM}.fifo & 
echo dos & 
java -jar ~/bin/VarScan.v2.3.2.jar somatic \
scratch/sedavis/${NORMALBAM}.fifo scratch/sedavis/${TUMORBAM}.fifo \
results/snp_calls/PE/${OUTFILE} 
#--output-vcf 1


echo listo 
rm scratch/sedavis/${TUMORBAM}.fifo
rm scratch/sedavis/${NORMALBAM}.fifo
#java -jar ~/bin/VarScan.v2.3.2.jar processSomatic results/snp_calls/PE/${OUTFILE}.snp
#java -jar ~/bin/VarScan.v2.3.2.jar processSomatic results/snp_calls/PE/${OUTFILE}.indel
