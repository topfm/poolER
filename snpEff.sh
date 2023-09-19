#!/bin/bash

# Run R script to generate VCF file from CSV input
Rscript csvToVCF.R $1

# Use the output file of the R script as input for the Java script
java -Xmx8g -jar /opt/PepPrograms/snpEff_v5.0/snpEff.jar GV_14018 outfile.vcf > snpEff.tsv

#run R script to combine 
Rscript combine.R $1
cat *final.csv > allFinal.csv