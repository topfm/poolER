#! bin/bash
#####
#Script to run Popoolation. Written by Madison Youngblom and edited by Madeline Topf.
# Usage: run_popoolation.sh <strain_name> <path/to/ref> <path/to/bed> <bam1> ... <bamN>
#####
strain="$1"
ref="$2"
bed="$3"
bams="${@:4}"
bams_renamed=()
for x in ${bams}
do
     #echo ${x/ready/final}
    bams_renamed+=(${x/ready/final})
done
# filter bams
echo "Filtering BAMs ..."
for x in ${bams};
do
samtools view -q 20 -b ${x} | samtools sort - -o ${x/ready/final}
done
# make mpileup file
echo "Creating mpileup file ..."
samtools mpileup -B -f ${ref} -o ${strain}.mpileup "${bams_renamed[@]}"
# convert mpileup file to sync
echo "Converting mpilup file to sync file ..."
mpileup2sync --input ${strain}.mpileup --output ${strain}.sync --fastq-type sanger --min-qual 20 --threads 4
# use python script to convert sync file to TSV
python3 poolER/popoolationSynctoTSV.py --bed ${bed} --min-count 5 --min-coverage 20 --min-freq 5 --output ${strain}_popoolation.tsv ${strain}.sync
