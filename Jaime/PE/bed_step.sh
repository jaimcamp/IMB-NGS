####

#use: bed_stage.sh <FILE_NAME> <G_REF> <PRE_REF> <NUM_T> <date>


FILE_NAME=$1
G_REF=$2
PRE_REF=$3
NUM_T=$4
fecha=$5

echo Name of the file to read: ${FILE_NAME}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}
echo Date: $fecha

#Log file definition

LOG=bed_${FILE_NAME}_${PRE_REF}_${fecha}.log

#Check existence of recal BAM file

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam  ];
	then
	echo results/aln/PE/${FILE_NAME}_${PRE_REF}.bam
	exit 2
fi
echo Alles gut!



#Intersect final BAM with BED file

#intersectBed -abam results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam -b bed_files/SureSelect_All_Exon_50mb_with_annotation_hg19_25contigs_wUniqueIdentifier_EXT200_concatenated_sorted.bed > results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam 

samtools index results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam  ];
        then
	echo results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam doesn\'t exists
	exit 2
fi      
echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam exists!

#Coverage of zone

#samtools view -uf 0x2 results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam | coverageBed -abam stdin -b bed_files/SureSelect_All_Exon_50mb_with_annotation_hg19_25contigs_wUniqueIdentifier_EXT200_concatenated_sorted.bed  > results/bed_results/PE/${FILE_NAME}_${PRE_REF}.cove.txt

#Get histogram coverage

#samtools view -uf 0x2 results/aln/PE/${FILE_NAME}_${PRE_REF}.b.recal.bam | coverageBed -abam stdin -b bed_files/SureSelect_All_Exon_50mb_with_annotation_hg19_25contigs_wUniqueIdentifier_EXT200_concatenated_sorted.bed -hist | grep ^all > results/bed_results/PE/${FILE_NAME}_${PRE_REF}.hist.txt


#Create BedGraph file

sed '1i track type=bedGraph name=\"${FILE_NAME}\"' < results/bed_results/PE/${FILE_NAME}_${PRE_REF}.cove.txt | awk '{OFS="\t"; print $1,$2,$3,$8, $4,$5,$6,$7}' > results/bed_results/PE/${FILE_NAME}_${PRE_REF}.cove.bedgraph


