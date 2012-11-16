#!/bin/bash

##############################################################
## 		      SNPs, INDELS & others  		    ##
##############################################################



#FILE_NAME
TYPE=$1

#G_REF=$2
#PRE_REF=$3
#NUM_T=$4
#fecha=$5

#echo Name of the file to read: ${FILE_NAME}
#echo Name of the genome ref to use: ${G_REF}
#echo Name of the prefix of the ref: ${PRE_REF}
#echo Number of threads to use: ${NUM_T}
DIR=~/xeno_project/results/snp_calls/PE

#Use SnpEff the files

for f in $DIR/$TYPE*.hc
do
	echo Processing $f
	java -jar ~/bin/snpEff_3_0a/snpEff.jar eff hg19 $f \
	-i txt -c ~/bin/snpEff_3_0a/snpEff.config -o txt > $f.temp
#	head $f.temp
	echo Ready $f SnpEff process
	tail -n+5 $f.temp | awk 'BEGIN { FS="\t"; OFS="\t" } { $2=$2 "\t" $2 } 1'  > $f.anno
#	head $f.anno
	echo ASDADSADSAD
	perl ~/bin/annovar/annotate_variation.pl -filter -dbtype snp132 \
	$f.anno ~/bin/annovar/humandb/ -buildver hg19

	echo Ready $f Annovar
	rm $DIR/$f.temp*
done


#java -jar ~/bin/snpEff_3_0a/snpEff.jar eff hg19 ~/xeno_project/results/metrics/PE/somatic_mouse.snp.Somatic.hc -i txt -c ~/bin/snpEff_3_0a/snpEff.config -o txt > 





#perl annotate_variation.pl -filter -dbtype snp135 ~/xeno_project/results/metrics/PE/somatic_brain.ann.snp.Somatic.hc humandb/ -buildver hg19







#Create mpileup file

#samtools mpileup -f genome/human/hg19.fa \
#results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam > \
#results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.mpileup

#Call somatic from VarScan

#java -jar ~/bin/VarScan.v2.3.2.jar somatic \
#results/aln/PE/${NORMAL_NAME}_${PRE_REF}.recal.mpileup \
#results/aln/PE/${CANCER_NAME}_${PRE_REF}.recal.mpileup \
#results/metrics/PE/somatic_mouse 


#Raw SNPs call

#java -Xmx5g -jar ~/bin/GATK/GenomeAnalysisTK.jar -T UnifiedGenotyper \
#-et NO_ET -K ~/bin/jaime.campos_valenzuela_mailbox.tu-dresden.de.key \
#-R genome/human/${G_REF} \
#-glm BOTH \
#-I results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam \
#-o results/snp_calls/PE/${FILE_NAME}_${PRE_REF}.vcf \
#-D genome/db/dbsnp_135.hg19.vcf \
#-stand_call_conf 50 \
#-stand_emit_conf 50 \
#-dcov 1000 \
#-A DepthOfCoverage \
#-A AlleleBalance \
#-L bed_files/SureSelect_All_Exon_50mb_with_annotation_hg19_25contigs_wUniqueIdentifier_EXT200_concatenated_sorted.bed \
#-metrics snps.metrics
