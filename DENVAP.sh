#! usr/bin/bash

mkdir {bams,consensus,dengue_reads,human_reads,mapping,non_dengue_reads,non_human_reads,reads,trimmed_reads,visualization_af,visualization_bf,results_dengue} ;

cd fastq;
for file in *barcode*; do cat $file/*.fastq > `echo $file`.fastq | chmod +x `echo $file`.fastq;done ; 
mv *.fastq ../reads ; cd .. 

cd fastq;
for file in *barcode??; do artic guppyplex --directory $file --min-length 150 --max-length 1500 --prefix ../trimmed_reads/DENV --quality 10;done ;  
cd .. 

snakemake -j1 -c10 -s visualization_bf.smk;
snakemake -j1 -c10 -s visualization_af.smk;

cd index;
cat human* > human_genome_GRCh38.fna.gz &&
rm -rf human_genome_GRCh38.fna.gz_*;
cd ..

cd trimmed_reads;
for file in *.fastq; do minimap2 -a -x map-ont -t 10 ../index/human_genome_GRCh38.fna.gz `echo ${file:0:29}`.fastq -o ../mapping/`echo ${file:0:29}`.bam; done ; 
cd .. 

cd mapping;
for file in *bam;do samtools fastq -F 3588 `echo ${file:0:29}`.bam | gzip -c > ../human_reads/`echo ${file:0:29}`.fastq.gz;done ; 
cd .. 

cd mapping;
for file in *bam;do samtools fastq -F 3584 `echo ${file:0:29}`.bam | gzip -c > ../non_human_reads/`echo ${file:0:29}`.fastq.gz;done ; 
cd .. 

cd non_human_reads;
for file in *.fastq.gz; do minimap2 -a -x map-ont -t 10 ../reference_dengue/DENV.reference.fasta `echo ${file:0:29}`.fastq.gz -o ../mapping/`echo ${file:0:29}`_DENV.bam; done ; 
cd .. 

cd mapping;
for file in *bam;do samtools fastq -F 3588 `echo ${file:0:29}`_DENV.bam | gzip -c > ../dengue_reads/`echo ${file:0:29}`.fastq.gz;done ; 
cd .. 

cd mapping;
for file in *bam;do samtools fastq -F 3584 `echo ${file:0:29}`_DENV.bam | gzip -c > ../non_dengue_reads/`echo ${file:0:29}`.fastq.gz;done ; 
cd .. 

cd dengue_reads;
for file in *.fastq.gz; do mkdir -p ../bams/`echo ${file:0:29}` ; minimap2 -a -x map-ont -t 10 ../reference_dengue/DENV.reference.fasta $file | samtools view -bS -F 4 - | samtools sort -o ../bams/`echo ${file:0:29}`/`echo ${file:0:29}`.sorted.bam -;done ; 
cd .. 

cd bams;
for file in *; do samtools index $file/$file.sorted.bam;done ; 
cd .. 

cd bams;
for file in *; do align_trim --normalise 200 ../reference_dengue/DENV.scheme.bed --start --remove-incorrect-pairs --report $file/$file.alignreport.txt < $file/$file.sorted.bam 2> ./$file/$file.alignreport.er | samtools sort -T $file - -o $file/$file.trimmed.rg.sorted.bam; done ; 
cd .. 

cd bams;
for file in *; do align_trim --normalise 200 ../reference_dengue/DENV.scheme.bed --remove-incorrect-pairs --report $file/$file.alignreport.txt < $file/$file.sorted.bam 2> $file/$file.alignreport.er | samtools sort -T $file - -o $file/$file.primertrimmed.rg.sorted.bam; done ; 
cd .. 

cd bams;
for file in *; do samtools index $file/$file.trimmed.rg.sorted.bam | samtools index $file/$file.primertrimmed.rg.sorted.bam; done ; 
cd .. 

cd bams;
for file in *; do artic_make_depth_mask --store-rg-depths ../reference_dengue/DENV.reference.fasta $file/$file.primertrimmed.rg.sorted.bam $file/$file.coverage_mask.txt; done ; 
cd .. 

cd bams;
for file in *; do samtools mpileup -aa -A -Q 0 -d 0 $file/$file.trimmed.rg.sorted.bam | ivar consensus -p $file/$file.fa -m 10 -n N -t 0.5; done ; 
cd .. 


cd bams;
for file in */*.fa ; do cp -r $file ../consensus/; done ; 
cd ..

cp fasta-coverage.py coverage.tsv -t consensus;
cd consensus;
cat *.fa > all_consensus.fasta
python fasta-coverage.py all_consensus* > coverage.tsv;
cd ..

zip `date "+%Y_%m_%d_%H:%M:%S"`.zip {bams/*/,dengue_reads,human_reads,mapping,non_dengue_reads,non_human_reads,reads,trimmed_reads,visualization_af/*/,visualization_bf/*/,consensus}/*; mv *.zip results_dengue;
rm -rf {bams,consensus,dengue_reads,human_reads,mapping,non_dengue_reads,non_human_reads,reads,trimmed_reads,visualization_af,visualization_bf}; rm -rf fastq/*
