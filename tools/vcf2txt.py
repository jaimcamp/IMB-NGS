#!/usr/bin/env python
'''
Created on 31.01.2012

@author: Stange
'''

import sys

def distinct24(l):
    return list(set(l))

def parseinfo(text):  # Funktion zum parsen einer Info-Spalte aus einem VCF-File
    infoline=19*['']
    aaChange=[]
    gn=[]
    gbioT=[]
    impGenes=[]
    info=text.split(";")
    for i in list(range(len(info))):
        item=info[i].split("=")
        if item[0]=="DP":
            infoline[1]=item[1].replace('.',',')
        elif item[0]=="DP4":
            z=item[1].split(",")
            infoline[2]=z[0].replace('.',',')
            infoline[3]=z[1].replace('.',',')
            infoline[4]=z[2].replace('.',',')
            infoline[5]=z[3].replace('.',',')
        elif item[0]=="MQ":
            infoline[6]=item[1].replace('.',',')
        elif item[0]=="FQ":
            infoline[7]=item[1].replace('.',',')
        elif item[0]=="AF1":
            infoline[8]=item[1].replace('.',',')
        elif item[0]=="AC1":
            infoline[9]=item[1].replace('.',',')
        elif item[0]=="PV4":
            z=item[1].split(",")
            infoline[10]=z[0].replace('.',',')
            infoline[11]=z[1].replace('.',',')
            infoline[12]=z[2].replace('.',',')
            infoline[13]=z[3].replace('.',',')
        elif item[0]=="VDB":
            infoline[14]=item[1].replace('.',',')
        elif item[0]=="EFF": 
            '''Gene_Name=5. Spalte, Gene_BioType=6. Spalte'''
            eff=item[1].split(",")
            for s_eff in eff:
                a_eff=s_eff.split("|")
                '''Gene Name der wichtigen Aenderungen'''
                a_effType=a_eff[0].split("(")
                if (a_effType[1]=='HIGH' or a_effType[0].startswith("NON_SYNONYMOUS_CODING")) and len(a_eff[4])>0 :
                    impGenes.append(a_eff[4])
                if (len(a_eff[3]) > 0) :
                    aaChange.append(a_eff[3])
                if (len(a_eff[4])>0) :
                    gn.append(a_eff[4])
                if (len(a_eff[5])>0):
                    gbioT.append(a_eff[5])
    if info[0]=="INDEL":
        infoline[0]="INDEL"
    else:
        infoline[0]="SNP"
    ''' keine Liste !!! '''
    aaChange=distinct24(aaChange)
    infoline[15]=','.join(aaChange)
    impGenes=distinct24(impGenes)
    infoline[16]=','.join(impGenes)
    gn=distinct24(gn)
    infoline[17]=','.join(gn)
    gbioT=distinct24(gbioT)
    infoline[18]=','.join(gbioT)
    return infoline


def main():

    '''Check argument'''
    if len(sys.argv) < 2:
        print("Please give a VCF file as argument")
        sys.exit(1)
    
    snpfile=str(sys.argv[1])
    newsnpfile=snpfile+'.txt'

    '''VCF-File oeffnen und einlesen'''
    snp = open(snpfile,'r') 
    snplines=snp.readlines()
    snp.close()

    
    '''Textfile zum schreiben oeffnen'''
    newsnp=open(newsnpfile,"w") 

    ''' Header lesen und schreiben'''
    anzahl=len(snplines)*1.0
    i=0
    for zeile in snplines:
        i=i+1.0
        p=i/anzahl*100.0
        sys.stdout.write("\r%d%%" %p)
        sys.stdout.flush()
        if (zeile[0:2]=="##"):
            newsnp.write(zeile)
            continue
        elif (zeile[0]=="#"): 
            header=[]
            header.extend(["CHROM","POS","ID","REF","ALT","QUAL","TYPE","DP","DPRF","DPRR","DPAF","DPAR","MQ","FQ","AF1","AC1","PVSB","PVBB","PVMB","PVTB","VDB","AAchange", "importantGene", "GeneName","GeneBiotype","INFO"])
            headerline='\t'.join(header[0:])+'\n'
            newsnp.write(headerline)
            continue
        else:
            snpcol=zeile.split("\t")
            line='\t'.join(snpcol[0:5])+'\t'+snpcol[5].replace('.',',')
            line=line.rstrip('\n')+'\t'+'\t'.join(parseinfo(snpcol[7]))+'\t'+snpcol[7]+'\n'
            '''print(line)'''
            newsnp.write(line)    
    newsnp.close
    print(' abgeschlossen')

if __name__=="__main__":
    main();
