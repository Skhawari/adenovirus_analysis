# workflow/rules/assembly.smk

rule spades:
    input:
        fq1 = "results/trimmed/{sample}_1.fq.gz",
        fq2 = "results/trimmed/{sample}_2.fq.gz"
    output:
        contigs = "results/assembly/{sample}/contigs.fasta"
    log:
        "results/assembly/{sample}/spades.log"
    threads: 8
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        spades.py -1 {input.fq1} -2 {input.fq2} -o results/assembly/{wildcards.sample} \
                  --threads {threads} &> {log}
        """

rule quast:
    input:
        "results/assembly/{sample}/contigs.fasta"
    output:
        "results/quast/{sample}/report.tsv"
    conda:
        "../envs/assembly.yaml"
    shell:
        "quast {input} -o results/quast/{wildcards.sample}"