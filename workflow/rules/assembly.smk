
rule spades:
    input:
        fq1 = "results/trimmed/{sample}_R1.fastq.gz",
        fq2 = "results/trimmed/{sample}_R2.fastq.gz"
    output:
        fasta = "results/assembly/{sample}/spades/contigs.fasta"
    log:
        "logs/assembly/{sample}.log"
    threads: 4
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        spades.py --phred-offset 33 -1 {input.fq1} -2 {input.fq2} -o results/assembly/{wildcards.sample}/spades -t {threads} > {log} 2>&1
        """

rule quast:
    input:
        fasta = "results/assembly/{sample}/spades/contigs.fasta"
    output:
        "results/quast/{sample}/report.txt"
    log:
        "logs/quast/{sample}.log"
    threads: 2
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        quast --threads {threads} -o results/quast/{wildcards.sample} {input.fasta} > {log} 2>&1
        """