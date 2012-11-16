#!/bin/bash
######################################################
### 		Pipeline for Pair-end reads	   ###
######################################################

#Initial directory ~/xeno_project

#This scripts is static


###Go to  folder###

LAUNCH_DIR=~/xeno_project
cd $LAUNCH_DIR

if  [ "`pwd`" = "${LAUNCH_DIR}" ]
        then
        echo Correct directory 
        else
        exit 2
fi


######## DATA #######


#Name of the files to be read#

FILE_NAME_1=L1206_Track-2045 #Tumor
FILE_NAME_2=L1207_Track-2046 #Blood
FILE_NAME_3=L1208_Track-2047 #Xeno


#Reference Genome to use#

G_REF=hg19.fa

#Prefix Genome#

PRE_REF=hg19

#Number of threads to use#

NUM_T=8

#Date#

fecha=$(date '+%y_%m_%d-%H:%M:%S')


#File to use
TYPE=recal



#Call scripts alignment

#bash ~/xeno_project/scripts/PE/aln_bwa.sh $FILE_NAME_1 $G_REF $PRE_REF $NUM_T $fecha
#bash ~/xeno_project/scripts/PE/aln_bwa.sh $FILE_NAME_2 $G_REF $PRE_REF $NUM_T $fecha
#bash ~/xeno_project/scripts/PE/aln_bwa.sh $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $fecha

#Call script post_alignment


#bash ~/xeno_project/scripts/PE/post_align.sh $FILE_NAME_1 $G_REF $PRE_REF $NUM_T $fecha 
#bash ~/xeno_project/scripts/PE/post_align.sh $FILE_NAME_2 $G_REF $PRE_REF $NUM_T $fecha
#bash ~/xeno_project/scripts/PE/post_align.sh $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $fecha

#Call script stats of resulting file


#bash ~/xeno_project/scripts/PE/stats_bam.sh $FILE_NAME_1 $G_REF $PRE_REF $NUM_T $TYPE $fecha
#bash ~/xeno_project/scripts/PE/stats_bam.sh $FILE_NAME_2 $G_REF $PRE_REF $NUM_T $TYPE $fecha
#bash ~/xeno_project/scripts/PE/stats_bam.sh $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $TYPE $fecha

#Bedtoos

bash ~/xeno_project/scripts/PE/bed_step.sh $FILE_NAME_1 $G_REF $PRE_REF $NUM_T $fecha &
bash ~/xeno_project/scripts/PE/bed_step.sh $FILE_NAME_2 $G_REF $PRE_REF $NUM_T $fecha &
bash ~/xeno_project/scripts/PE/bed_step.sh $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $fecha 



