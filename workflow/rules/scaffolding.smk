rule ragtag_scaffold:
    input:
        reference = config["ref"],
        contigs = "results/assembly/{sample}/contigs.fasta"
    output:
        scaffold = "results/scaffolds/{sample}/ragtag.scaffold.fasta"
    log:
        "results/scaffolds/{sample}.log"
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        ragtag.py scaffold {input.reference} {input.contigs} -o results/scaffolds/{wildcards.sample} \
            &> {log}
        """