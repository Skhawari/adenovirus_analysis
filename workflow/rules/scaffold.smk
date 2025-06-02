rule ragtag_scaffold:
    input:
        contigs = "results/assembly/{sample}/spades/contigs.fasta",
        ref = config["ragtag_ref"]
    output:
        scaffold = "results/scaffold/{sample}/ragtag.scaffold.fasta"
    log:
        "logs/ragtag/{sample}.log"
    threads: 2
    conda:
        "../envs/scaffold.yaml"
    shell:
        """
        ragtag.py scaffold \
            -o results/scaffold/{wildcards.sample} \
            {input.ref} {input.contigs} &> {log}
        """