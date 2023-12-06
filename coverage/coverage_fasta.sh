echo -e "File\tSample\tCoverage" > coverage.tsv

for file in *.fa
do	
	python /home/artic/data/analysis/20231130_DENGUE_TCHAD/DENGUE/coverage/fasta-coverage.py "$file" >> coverage.tsv
done
