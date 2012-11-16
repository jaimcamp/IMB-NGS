#!/bin/bash

#Files to work
HUMAN=$1
MOUSE=$2

#Save header

#head -n 27 $HUMAN > $HUMAN.h
#head -n 24 $MOUSE > $MOUSE.h

#Save the body of the file

#tail -n+28 $HUMAN > $HUMAN.b 
#tail -n+25 $MOUSE > $MOUSE.b 

#Divide the files in X smallers

x=1000
t_lines=( $(wc -l $HUMAN.b) )

f_lines=$(( $t_lines / $x ))

#Create temporal directory

#mkdir temp_comp

cd temp_comp

#split -l $f_lines ../$HUMAN.b HUMAN -d -a 4
#split -l $f_lines ../$MOUSE.b MOUSE -d -a 4

echo $f_lines 

#Loop over all files

for i in `eval echo {0000..$x}`
do
    echo $HUMAN$i
    paste <( awk '{print $1}' MOUSE$i) <( awk '{print $1}' HUMAN$i) > names.$i.txt
    awk ' { sum+= $1!=$2 } END {print sum} ' names.$i.txt > f_names.$i.txt
    paste <( awk '{print $5}' MOUSE$i) <( awk '{print $5}' HUMAN$i) > mapq.$i.txt
    awk '{print $2 <= $1}' mapq.$i.txt | awk '{if ($1==1) print NR}'> f_mapq.$i.txt
    python ../fill_pairs.py f_mapq.$i.txt
    awk '{print $1 "p"}' f_mapq.$i.txt > p_reads.$i.txt
    awk '{print $1 "d"}' f_mapq.$i.txt > d_reads.$i.txt
    sed -n -f p_reads.$i.txt HUMAN$i > HUMAN.p.$i
    sed -n -f p_reads.$i.txt MOUSE$i > MOUSE.p.$i
    sed -f d_reads.$i.txt HUMAN$i > HUMAN.d.$i
    sed -f d_reads.$i.txt MOUSE$i > MOUSE.d.$i
    # awk '{print $1 FILENAME}' d_reads.$i.txt > ej.$i.txt

done

# cat ej.* > ej.txt
cat HUMAN.d.* > ../$HUMAN.d
cat HUMAN.p.* > ../$HUMAN.p
cat MOUSE.p.* > ../$MOUSE.p
cat MOUSE.d.* > ../$MOUSE.d
cd ..
java -jar ~/bin/picard-tools-1.72/ReplaceSamHeader.jar I=results/aln/PE/L1208_Track-2047_hg19.sam.d HEADER=results/aln/PE/L1208_Track-2047_hg19.sam.h O=results/aln/PE/L1208_Track-2047_hg19.f.bam

exit 2

