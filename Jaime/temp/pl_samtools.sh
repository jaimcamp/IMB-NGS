####

#use: aln_samtools.sh <FILE_NAME> <G_REF> <PRE_REF> <NUM_T> <date>
echo $1
echo $2
echo $3
echo $4
echo $5

FILE_NAME = $1
G_REF = $2
PRE_REF = $3
NUM_T = $4
fecha = $5


echo Name of the file to read: ${FILE_NAME}
echo Name of the genome ref to use: ${G_REF}
echo Name of the prefix of the ref: ${PRE_REF}
echo Number of threads to use: ${NUM_T}

#Read @RG data

PL=cut -f1 scripts/${FILE_NAME}_data.csv
CN=cut -f2 scripts/${FILE_NAME}_data.csv
SM=cut -f3 scripts/${FILE_NAME}_data.csv
LB=cut -f4 scripts/${FILE_NAME}_data.csv
ID=cut -f5 scripts/${FILE_NAME}_data.csv
PU=cut -f6 scripts/${FILE_NAME}_data.csv

 
bwa aln -t ${NUM_T} -f results/${FILE_NAME}_${PRE_REF}.sai  genome/${PRE_REF} rawdata/${FILE_NAME}.fastq.gz | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log



bwa samse -f results/${FILE_NAME}_${PRE_REF}.sam -r "@RG\tID:${ID}\tLB:${LB}\tSM:${SM}\tPL:${PL}\tPG:${PG}\tPU:${PU}"  genome/${PRE_REF} results/${FILE_NAME}_${PRE_REF}.sai rawdata/${FILE_NAME}.fastq.gz | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log



samtools view -bS -q 1 results/${FILE_NAME}_${PRE_REF}.sam | samtools sort - results/${FILE_NAME}_${PRE_REF}.sam.sorted | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log



samtools rmdup -s results/${FILE_NAME}_${PRE_REF}.sam.sorted.bam results/${FILE_NAME}_${PRE_REF}.sam.sorted.noDup.bam | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log


samtools index results/${FILE_NAME}_${PRE_REF}.sam.sorted.noDup.bam | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log




samtools flagstat results/${FILE_NAME}_${PRE_REF}.sam.sorted.noDup.bam | tee -a logs/log_${FILE_NAME}_${PRE_REF}_${fecha}.log





