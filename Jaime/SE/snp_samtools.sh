#use:snp_samtools.sh <FILE_NAME_1> <FILE_NAME_2> <FILE_NAME_3> <G_REF> <PRE_REF> <NUM_T> <fecha>



FILE_NAME1=$1
FILE_NAME2=$2
FILE_NAME3=$3
G_REF=$4
PRE_REF=$5
NUM_T=$6
fecha=$7

echo Name of the files to read: ${FILE_NAME1} ${FILE_NAME2} ${FILE_NAME3}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}

dbsnp="dbsnp_135.b37.vcf"

#Creates VCF for 3 samples

#samtools mpileup -d 10000 -B -C 50 -uf genome/${G_REF} results/${FILE_NAME1}_${PRE_REF}.sam.sorted.noDup.q30.bam results/${FILE_NAME2}_${PRE_REF}.sam.sorted.noDup.q30.bam results/${FILE_NAME3}_${PRE_REF}.sam.sorted.noDup.q30.bam  | bcftools view -vcg - > results/xeno_project_${PRE_REF}.q30.B.raw.vcf

# 
#samtools mpileup -uf genome/${G_REF} results/${FILE_NAME1}_${PRE_REF}.sam.sorted.noDup.q30.bam results/${FILE_NAME2}_${PRE_REF}.sam.sorted.noDup.q30.bam results/${FILE_NAME3}_${PRE_REF}.sam.sorted.noDup.q30.bam > results/xeno_project_${PRE_REF}.q30.pileup

#samtools mpileup -uf genome/${G_REF} results/${FILE_NAME1}_${PRE_REF}.sam.sorted.noDup.q30.bam | bcftools view -vcg - > results/${FILE_NAME1}_${PRE_REF}.q30.var.raw.vcf


#samtools mpileup -uf genome/${G_REF} results/${FILE_NAME2}_${PRE_REF}.sam.sorted.noDup.q30.bam | bcftools view -vcg - > results/${FILE_NAME2}_${PRE_REF}.q30.var.raw.vcf

#samtools mpileup -uf genome/${G_REF} results/${FILE_NAME3}_${PRE_REF}.sam.sorted.noDup.q30.bam | bcftools view -vcg - > results/${FILE_NAME3}_${PRE_REF}.q30.var.raw.vcf

samtools mpileup  -d 10000 -B -C 50 -P Illumina  -f genome/${G_REF} results/bed_temp/${FILE_NAME1}_${PRE_REF}.q30.bed.bam > results/bed_temp/${FILE_NAME1}_${PRE_REF}.q30.bed.pileup

samtools mpileup  -d 10000 -B -C 50 -P Illumina  -f genome/${G_REF} results/bed_temp/${FILE_NAME2}_${PRE_REF}.q30.bed.bam > results/bed_temp/${FILE_NAME2}_${PRE_REF}.q30.bed.pileup

samtools mpileup  -d 10000 -B -C 50 -P Illumina  -f genome/${G_REF} results/bed_temp/${FILE_NAME3}_${PRE_REF}.q30.bed.bam > results/bed_temp/${FILE_NAME3}_${PRE_REF}.q30.bed.pileup



#samtools mpileup  -d 10000 -B -C 50 -P Illumina  -f genome/${G_REF} results/${FILE_NAME2}_${PRE_REF}.sam.sorted.noDup.q30.bam > results/${FILE_NAME2}_${PRE_REF}.q30.B.pileup

#samtools mpileup  -d 10000 -B -C 50 -P Illumina  -f genome/${G_REF} results/${FILE_NAME3}_${PRE_REF}.sam.sorted.noDup.q30.bam > results/${FILE_NAME3}_${PRE_REF}.q30.B.pileup




#~/bin/samtools/bcftools/vcfutils.pl varFilter -Q 10 -a 5 -d 15 xeno_project_${PRE_REF}.sam.sorted.noDup.bam.samtools.var.raw.vcf > xeno_project_${PRE_REF}.sam.sorted.noDup.bam.samtools.var.filtered.vcf 

#Filtering vcf

#cat results/xeno_project_${PRE_REF}.q30.B.raw.vcf | java -jar ~/bin/SnpSift_latest.jar filter "(DP >= 5) &  ((( exists INDEL ) & (QUAL >= 20)) | (QUAL >= 30 ))" > results/xeno_project_${PRE_REF}.q30.B.filtered.vcf

#java -jar ~/bin/SnpSift_latest.jar annotate genome/${dbsnp}  results/xeno_project_${PRE_REF}.q30.B.filtered.vcf > results/xeno_project_${PRE_REF}.q30.B.filtered.anno.vcf


#java -jar ~/bin/snpEff_3_0a/snpEff.jar eff -v hg19 -c ~/bin/snpEff_3_0a/snpEff.config results/xeno_project_${PRE_REF}.q30.B.filtered.anno.vcf > results/xeno_project_${PRE_REF}.q30.B.filtered.anno.eff.vcf

#Somatic calls for the 3 comparisons: Blood-Tumor; Xenograft-Tumor; Blood-Xenograft



java -jar ~/bin/VarScan.v2.2.11.jar somatic results/bed_temp/${FILE_NAME2}_${PRE_REF}.q30.bed.pileup results/bed_temp/${FILE_NAME1}_${PRE_REF}.q30.bed.pileup results/metrics/somatic_tumor   --min-coverage 4 1> results/metrics/somatic_tumor_metric 2> results/metrics/somatic_tumor_metric

java -jar ~/bin/VarScan.v2.2.11.jar somatic results/bed_temp/${FILE_NAME2}_${PRE_REF}.q30.bed.pileup results/bed_temp/${FILE_NAME3}_${PRE_REF}.q30.bed.pileup results/metrics/somatic_mouse   --min-coverage 4 1> results/metrics/somatic_mouse_metric 2> results/metrics/somatic_mouse_metric

java -jar ~/bin/VarScan.v2.2.11.jar somatic results/bed_temp/${FILE_NAME1}_${PRE_REF}.q30.bed.pileup results/bed_temp/${FILE_NAME3}_${PRE_REF}.q30.bed.pileup results/metrics/somatic_tumor-mouse   --min-coverage 4 1> results/metrics/somatic_tumor-mouse_metric 2> results/metrics/somatic_tumor-mouse_metric


