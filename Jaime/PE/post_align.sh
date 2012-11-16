####

#use: post_align.sh <FILE_NAME> <G_REF> <PRE_REF> <NUM_T> <date>


FILE_NAME=$1
G_REF=$2
PRE_REF=$3
NUM_T=$4
fecha=$5

echo Name of the file to read: ${FILE_NAME}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}


#Log file definition

LOG=post_align_${FILE_NAME}_${PRE_REF}_${fecha}.log
if [ ! -f post_align_${FILE_NAME}_${PRE_REF}_${fecha}.log  ];
then
	rm post_align_${FILE_NAME}_${PRE_REF}_${fecha}.log
fi


#Check existence of BAM file

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.bam  ];
then   
        echo results/aln/PE/${FILE_NAME}_${PRE_REF}.bam
	exit 2
fi

echo Alles gut!

#Merge lane bam files - Not use in current pipeline

#java -jar ~/bin/picard-tools-1.72/MergeSamFiles.jar I=results/aln/PE/L1206_Track-2045_hg19_sort.bam I=results/aln/PE/L1207_Track-2046_hg19_sort.bam I=results/aln/PE/L1208_Track-2047_hg19_sort.bam O=results/aln/PE/xeno_hg19.bam SORT_ORDER=coordinate MERGE_SEQUENCE_DICTIONARIES=true ASSUME_SORTED=true USE_THREADING=true VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true

#Mark Duplicates

java -Xmx4g -Djava.io.tmpdir=/tmp -jar ~/bin/picard-tools-1.72/MarkDuplicates.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.bam \
OUTPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam \
METRICS_FILE=results/metrics/PE/mark_dup_${FILE_NAME}_${PRE_REF}_${fecha}.metric \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=SILENT 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}


if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam  ];
then   
        echo results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam doesn\'t exist!
        exit 2
fi
	echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam exists!



#Local realignment

java -Xmx4g -jar ~/bin/GATK/GenomeAnalysisTK.jar  -T RealignerTargetCreator \
-R genome/human/${G_REF} -o results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list  \
-I results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam \
-known genome/db/Mills_and_1000G_gold_standard.indels.hg19.vcf \
-et NO_ET \
-K ~/bin/jaime.campos_valenzuela_mailbox.tu-dresden.de.key -l INFO \
1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list  ];
then   
        echo results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list doesn\'t exist!
	exit 2  
fi      
echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list	exists!



# IndelRealigner

java -Xmx5g -jar ~/bin/GATK/GenomeAnalysisTK.jar -T IndelRealigner \
-R genome/human/${G_REF} -I results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.bam \
-targetIntervals results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list \
-known genome/db/Mills_and_1000G_gold_standard.indels.hg19.vcf \
-o results/aln/PE/${FILE_NAME}_${PRE_REF}.ra.bam \
-et NO_ET \
-K ~/bin/jaime.campos_valenzuela_mailbox.tu-dresden.de.key -l INFO \
1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.ra.bam  ];
then   
        echo results/aln/SE/${FILE_NAME}_${PRE_REF}.ra.bam doesn\'t exist!
	exit 2          
fi 
echo Alles gut! results/aln/SE/${FILE_NAME}_${PRE_REF}.ra.bam exists!

rm results/aln/PE/${FILE_NAME}_${PRE_REF}.marked.ba*
rm results/aln/PE/${FILE_NAME}_${PRE_REF}.bam.list

#FixMate

java -Xmx5g -Djava.io.tmpdir=/tmp/ -jar ~/bin/picard-tools-1.72/FixMateInformation.jar \
INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.ra.bam \
OUTPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam \
SO=coordinate VALIDATION_STRINGENCY=SILENT \
CREATE_INDEX=true 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam  ];
then   
        echo results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam doesn\'t 	exist!
	exit 2                
fi      
	echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam exists!


rm results/aln/PE/${FILE_NAME}_${PRE_REF}.ra.*

#QualityScoreRecalibration

java -Xmx4g -jar ~/bin/GATK/GenomeAnalysisTK.jar   -T BaseRecalibrator \
-I results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam  -R genome/human/${G_REF} \
-knownSites genome/db/dbsnp_135.hg19.vcf \
-o results/aln/PE/recal_data_${FILE_NAME}_${PRE_REF}.grp -et NO_ET \
-K ~/bin/jaime.campos_valenzuela_mailbox.tu-dresden.de.key -l INFO \
1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

if [ ! -f results/aln/PE/recal_data_${FILE_NAME}_${PRE_REF}.grp  ];
        then
        echo results/aln/PE/recal_data_${FILE_NAME}_${PRE_REF}.grp doesn\'t  exist!
	exit 2                
fi      
echo Alles gut!	results/aln/PE/recal_data_${FILE_NAME}_${PRE_REF}.grp exists!



#Print new BAM

java -Xmx4g -jar ~/bin/GATK/GenomeAnalysisTK.jar -T PrintReads \
-R genome/human/${G_REF} -I results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.bam \
-BQSR results/aln/PE/recal_data_${FILE_NAME}_${PRE_REF}.grp \
-o results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam  \
-et NO_ET -K ~/bin/jaime.campos_valenzuela_mailbox.tu-dresden.de.key \
1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

if [ ! -f results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam  ];
        then
	echo results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam doesn\'t  exist!
	exit 2                
fi      
echo Alles gut! results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam exists!


rm results/aln/PE/${FILE_NAME}_${PRE_REF}.fixed.*

echo New File
echo results/aln/PE/${FILE_NAME}_${PRE_REF}.recal.bam and




