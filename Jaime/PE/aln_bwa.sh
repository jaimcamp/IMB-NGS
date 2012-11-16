####

#use: aln_bwa.sh <FILE_NAME> <G_REF> <PRE_REF> <NUM_T> <date>


FILE_NAME=$1
G_REF=$2
PRE_REF=$3
NUM_T=$4
fecha=$5

echo Name of the file to read: ${FILE_NAME}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}




PL=`cut -f1 scripts/${FILE_NAME}_data.csv`
CN=`cut -f2 scripts/${FILE_NAME}_data.csv`
SM=`cut -f3 scripts/${FILE_NAME}_data.csv`
LB=`cut -f4 scripts/${FILE_NAME}_data.csv`
ID=`cut -f5 scripts/${FILE_NAME}_data.csv`
PU=`cut -f6 scripts/${FILE_NAME}_data.csv`

LOG=aln_log_${FILE_NAME}_${PRE_REF}_${fecha}.log

#Check existence of the raw data

if [ ! -f rawdata/PE/${FILE_NAME}_R1.fastq.gz  ];
then 
	echo ${FILE_NAME}_R1.fastq.gz does not exit!
	exit 2
fi

if [ ! -f rawdata/PE/${FILE_NAME}_R2.fastq.gz  ];
then
        echo ${FILE_NAME}_R2.fastq.gz does not exit!
	        exit 2
fi

echo Alles gut!

#ALN R1

bwa aln -t ${NUM_T} -f results/aln/PE/${FILE_NAME}_R1_${PRE_REF}.sai  genome/human/${PRE_REF} rawdata/PE/${FILE_NAME}_R1.fastq.gz 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

#ALN R2

bwa aln -t ${NUM_T} -f results/aln/PE/${FILE_NAME}_R2_${PRE_REF}.sai  genome/human/${PRE_REF} rawdata/PE/${FILE_NAME}_R2.fastq.gz 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

#SAI2SAM

bwa sampe -r "@RG\tID:${ID}\tLB:${LB}\tSM:${SM}\tPL:${PL}\tCN:${CN}\tPU:${PU}" -P genome/human/${PRE_REF} results/aln/PE/${FILE_NAME}_R1_${PRE_REF}.sai results/aln/PE/${FILE_NAME}_R2_${PRE_REF}.sai rawdata/PE/${FILE_NAME}_R1.fastq.gz rawdata/PE/${FILE_NAME}_R2.fastq.gz -f results/aln/PE/${FILE_NAME}_${PRE_REF}.sam 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG} 

rm results/aln/PE/${FILE_NAME}_R1_${PRE_REF}.sai results/aln/PE/${FILE_NAME}_R2_${PRE_REF}.sai

#SAM2BAM

samtools view -bS -o results/aln/PE/${FILE_NAME}_${PRE_REF}.bam results/aln/PE/${FILE_NAME}_${PRE_REF}.sam  1> results/logs/PE/${LOG} 2> results/logs/PE/${LOG}

 

#Sort with Picardtools

#java -Xmx4g -jar ~/bin/picard-tools-1.72/SortSam.jar  INPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.sam OUTPUT=results/aln/PE/${FILE_NAME}_${PRE_REF}.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true 1>> results/logs/PE/${LOG} 2>> results/logs/PE/${LOG}

#rm results/aln/PE/${FILE_NAME}_${PRE_REF}.sam

echo Raw bam file ready: results/aln/PE/${FILE_NAME}_${PRE_REF}.bam

