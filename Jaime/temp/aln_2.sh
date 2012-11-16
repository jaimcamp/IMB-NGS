####Initial test of the pipeline
######################################################

#Initial directory ~/xeno_project

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


##Name of the files to be read###

FILE_NAME_1=L1206_Track-1452_R1
FILE_NAME_2=L1207_Track-1453_R1
FILE_NAME_3=L1208_Track-1454_R1


#Reference Genome to use###

G_REF=human_g1k_v37.fasta

#Prefix Genome#

PRE_REF=g1k.h19


##Number of threads to use###

NUM_T=8

fecha=$(date '+%y_%m_%d-%H:%M:%S')

#Call scripts alignment 

#bash ~/xeno_project/scripts/aln_samtools.sh $FILE_NAME_1 $G_REF $PRE_REF $NUM_T $fecha

#bash ~/xeno_project/scripts/aln_samtools.sh $FILE_NAME_2 $G_REF $PRE_REF $NUM_T $fecha

#bash ~/xeno_project/scripts/aln_samtools.sh $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $fecha

#Call SNPs

bash ~/xeno_project/scripts/snp_samtools.sh $FILE_NAME_1 $FILE_NAME_2 $FILE_NAME_3 $G_REF $PRE_REF $NUM_T $fecha


