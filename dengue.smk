FASTQ, = glob_wildcards("reads/{fastq}.fastq")

rule all:
    input:
        expand("visualization_bf/{fastq}/", fastq = FASTQ),

rule visualization_bf:
    input:
        barcode = "reads/{fastq}.fastq"
    output:
        visa_bf = directory("visualization_bf/{fastq}/")
    log:
        "visualization_bf/{fastq}.log"
    shell:
        "mkdir -p {output.visa_bf} && "
        "NanoPlot -t 2 --fastq {input.barcode} -o {output.visa_bf}"