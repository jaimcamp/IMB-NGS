##########################################
#### Stats for BAMS files 		##
##########################################


#use: stats_bam.sh <FILE_NAME> <G_REF> <PRE_REF> <NUM_T> <TYPE> <date>


FILE_NAME=$1
G_REF=$2
PRE_REF=$3
NUM_T=$4
TYPE=$5
fecha=$6

echo Name of the file to read: ${FILE_NAME}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}
echo Type of BAM to process: ${TYPE}
echo Date: ${fecha}

#Check existence of file

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam  ];
	then
	echo results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam doesn\'t exists
	exit 2
fi
echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam exists



echo Starting flagstat study
echo Result in results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.txt

samtools flagstat results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam \
> results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_flagstat.txt

echo Starting Picard CollectAlignmentSummaryMetrics step

java -Xmx5g -jar ~/bin/picard-tools-1.72/CollectAlignmentSummaryMetrics.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam \
OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_MappingMetrics.txt \
VALIDATION_STRINGENCY=SILENT REFERENCE_SEQUENCE=genome/human/${G_REF} ASSUME_SORTED=true \
IS_BISULFITE_SEQUENCED=false 

echo Starting Picard MeanQualityByCycle step

java -Xmx2g -jar ~/bin/picard-tools-1.72/MeanQualityByCycle.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam \
OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_QualByCycleMetrics.txt \
CHART_OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_QualByCycleMetrics.pdf	\
VALIDATION_STRINGENCY=SILENT ALIGNED_READS_ONLY=true ASSUME_SORTED=true \
REFERENCE_SEQUENCE=genome/human/${G_REF}


echo Starting Picard QualityScoreDistribution step

java -Xmx2g -jar ~/bin/picard-tools-1.72/QualityScoreDistribution.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam \
REFERENCE_SEQUENCE=genome/human/${G_REF} \
OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_QualScoreDist.txt \
CHART_OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_QualScoreDist.pdf \
ALIGNED_READS_ONLY=true VALIDATION_STRINGENCY=SILENT ASSUME_SORTED=true


echo Starting Picard CollectInsertSizeMetrics step


java -Xmx2g -jar ~/bin/picard-tools-1.72/CollectInsertSizeMetrics.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.${TYPE}.bam \
OUTPUT=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_InsertMetrics.txt \
HISTOGRAM_FILE=results/metrics/PE/${FILE_NAME}_${PRE_REF}.${TYPE}_Picard_InsertMetrics.pdf \
VALIDATION_STRINGENCY=SILENT ASSUME_SORTED=true \
REFERENCE_SEQUENCE=genome/human/${G_REF}


#java -Xmx2g -jar ~/bin/picard-tools-1.72/CalculateHsMetrics.jar \
#BAIT_INTERVALS=${CAPTURE_BAITS} TARGET_INTERVALS=${TARGET_INTERVALS} \
#INPUT=${SAMPLE_BASENAME}_${GENOME_NAME}_${BWA_TAG}_ir_recal_dm.bam \
#OUTPUT=${SAMPLE_BASENAME}_${GENOME_NAME}_${BWA_TAG}_Picard_CaptureMetrics.txt \
#METRIC_ACCUMULATION_LEVEL=ALL_READS REFERENCE_SEQUENCE=${REFERENCE_FILE} \
#PER_TARGET_COVERAGE=${SAMPLE_BASENAME}_${GENOME_NAME}_${BWA_TAG}_Picard_CaptureTargetMetrics.txt \
#VALIDATION_STRINGENCY=SILENT 



