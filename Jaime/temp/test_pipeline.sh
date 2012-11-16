####################################################
#Initial test of the pipeline
######################################################

#Initial directory ~/ngs

#This scripts is static


####Go to  folder###

LAUNCH_DIR=~/xeno_project
cd $LAUNCH_DIR

if  [ "`pwd`" = "${LAUNCH_DIR}" ]
        then
	echo Correct directory 
	else
	exit 2
fi

echo Name of the file to read - Only works for single-end reads
read FILE_NAME
echo Name of the genome ref to use
read G_REF
echo Name of the prefix of the ref
read PRE_REF
echo Number of threads to use
read NUM_T
fecha=$(date '+%m_%d_%y-%H:%M:%S')

#INDEX
echo Do you wanna create the index of the reference genome? [yes/no]
read INDEX_REF

if [ "$INDEX_REF" = 'yes' ]
	then 
echo  -e ----------------------------- '\n' Starting indexing '\n' -------------------------| tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log
bwa index -a bwtsw -p genome/${PRE_REF} genome/${G_REF} | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log
	elif [ "$INDEX_REF"=="no" ]
	then 
	echo No indexing
	else 
	echo wrong answer
	fi 

#Alignment 
echo -e ----------------------------- '\n' First: Aligment '\n' -------------------------| tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log

bwa aln -t ${NUM_T} -f results/${FILE_NAME}_${PRE_REF}.sai  genome/${PRE_REF} rawdata/${FILE_NAME}.fastq.gz | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log

#without -I for newer format - Sanger
exit 2



echo -e ----------------------------- '\n' Second: SAI to SAM '\n' -------------------------| tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log

bwa samse -f results/${FILE_NAME}_${PRE_REF}.sam -r "@RG\tID:Exome1\tLB:Exome1\tSM:Exome1\tPL:ILLUMINA\tPG:bwa"  genome/${PRE_REF} results/${FILE_NAME}_${PRE_REF}.sai
rawdata/L1206_Track-1452_R1.fastq # -r  need! read group needed for indelrealigner!

#When use sortsam with VALIDATION_STRINGENCY=LENIENT you get 4 errors.





echo -e ----------------------------- '\n' First: PCR Marking '\n' -------------------------| tee -a logs/log_test.log
date '+%m/%d/%y %H:%M:%S' | tee -a logs/log_test.log
exit 2
java -Xmx8g -Djava.io.tmpdir=/tmp -jar ~/bin/picard-tools-1.72/MarkDuplicates.jar INPUT=results/L1206_Track-1452_R1.bam \
OUTPUT=results/L1206_Track-1452_R1.marked.bam \
METRICS_FILE=metrics \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

echo Second: Realigner something | tee -a logs/log_test.log
date '+%m/%d/%y %H:%M:%S' | tee -a logs/log_test.log


java -Xmx8g -jar ~/bin/GenomeAnalysisTK-1.6-13-g91f02df/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R genome/human_g1k_v37.fasta \
-o results/L1206_Track-1452_R1.bam.list \
-I results/L1206_Track-1452_R1.marked.bam -nt 8


echo Third Indel realigner | tee -a logs/log_test.log
date '+%m/%d/%y %H:%M:%S' | tee -a logs/log_test.log


java -Xmx8g -Djava.io.tmpdir=/tmp \
       	 -jar ~/bin/GenomeAnalysisTK-1.6-13-g91f02df/GenomeAnalysisTK.jar \
       	 -I results/L1206_Track-1452_R1.marked.bam \
       	 -R genome/human_g1k_v37.fasta \
       	 -T IndelRealigner \
       	 -targetIntervals results/L1206_Track-1452_R1.bam.list \
	 -o results/L1206_Track-1452_R1.marked.realigned.bam


echo Fourth CountCovariates | tee -a logs/log_test.log
date '+%m/%d/%y %H:%M:%S' | tee -a logs/log_test.log

java -Xmx8g -Djava.io.tmpdir=/tmp -jar ~/bin/GenomeAnalysisTK-1.6-13-g91f02df/GenomeAnalysisTK.jar \
        -l INFO \
        -R genome/human_g1k_v37.fasta \
        -knownSites genome/dbsnp_135.b37.vcf \
        -I results/L1206_Track-1452_R1.marked.realigned.bam \
        -T CountCovariates \
        -cov ReadGroupCovariate \
        -cov QualityScoreCovariate \
        -cov CycleCovariate \
        -cov DinucCovariate \
        -recalFile results/L1206_Track-1452_R1.recal_data.csv -nt 8


echo Fifth TableRecalibration | tee -a logs/log_test.log
date '+%m/%d/%y %H:%M:%S' | tee -a logs/log_test.log

java -Xmx8g -Djava.io.tmpdir=/tmp  -jar ~/bin/GenomeAnalysisTK-1.6-13-g91f02df/GenomeAnalysisTK.jar \
-l INFO \
-R genome/human_g1k_v37.fasta \
-I results/L1206_Track-1452_R1.marked.realigned.bam \
-T TableRecalibration \
--out results/L1206_Track-1452_R1.marked.realigned.fixed.recal.bam \
-recalFile results/L1206_Track-1452_R1.recal_data.csv 

echo LISTO!





 
