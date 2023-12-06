FASTQ, = glob_wildcards("trimmed_reads/{fastq}.fastq")

rule all:
    input:
        expand("mapping/{fastq}.bam", fastq = FASTQ),
        expand("human_reads/{fastq}.bam", fastq = FASTQ),
        expand("human_reads/{fastq}.fastq.gz", fastq = FASTQ),
        expand("non_human_reads/{fastq}.bam", fastq = FASTQ),
        expand("non_human_reads/{fastq}.fastq.gz", fastq = FASTQ)


rule mapping:
    input:
        ref = "index/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz",
        fastq = "trimmed_reads/{fastq}.fastq"
    output:
        bam = "mapping/{fastq}.bam"
    log:
        "mapping/{fastq}.log"
    shell:
        "minimap2 -a -x map-ont -t 10 {input.ref} {input.fastq} -o {output.bam}"
rule human:
    input:
        bam = "mapping/{fastq}.bam"
    output:
        bam = "human_reads/{fastq}.bam",
        fastq = "human_reads/{fastq}.fastq.gz"
    log:
        "human_reads/{fastq}.log"
    shell:
        "samtools fastq -F 3588 {output.bam} | gzip -c > {output.fastq}"
rule non_human:
    input:
        bam = "mapping/{fastq}.bam"
    output:
        bam = "non_human_reads/{fastq}.bam",
        fastq = "non_human_reads/{fastq}.fastq.gz"
    log:
        "non_human_reads/{fastq}.log"
    shell:
        "samtools fastq -F 3584 {output.bam} | gzip -c > {output.fastq}"
