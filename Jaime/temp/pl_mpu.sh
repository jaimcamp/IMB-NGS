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




samtools mpileup -uf genome/${G_REF} results/${FILE_NAME1}_${PRE_REF}.sam.sorted.noDup.bam results/${FILE_NAME2}_${PRE_REF}.sam.sorted.noDup.bam results/${FILE_NAME3}_${PRE_REF}.sam.sorted.noDup.bam  | bcftools view -vcg - > xeno_project_${PRE_REF}.sam.sorted.noDup.bam.samtools.var.raw.vcf


~/bin/samtools/bcftools/vcfutils.pl varFilter -Q 10 -a 5 -d 15 xeno_project_${PRE_REF}.sam.sorted.noDup.bam.samtools.var.raw.vcf > xeno_project_${PRE_REF}.sam.sorted.noDup.bam.samtools.var.filtered.vcf 

