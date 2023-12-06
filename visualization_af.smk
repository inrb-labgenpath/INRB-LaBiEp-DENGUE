FASTQ, = glob_wildcards("trimmed_reads/{fastq}.fastq")

rule all:
    input:
        expand("visualization_af/{fastq}/", fastq = FASTQ),

rule visualization_af:
    input:
        barcode = "trimmed_reads/{fastq}.fastq"
    output:
        visa_af = directory("visualization_af/{fastq}/")
    log:
        "visualization_af/{fastq}.log"
    shell:
        "mkdir -p {output.visa_af} && "
        "NanoPlot -t 2 --fastq {input.barcode} -o {output.visa_af}"