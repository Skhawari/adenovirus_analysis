# workflow/rules/phylogeny.smk

rule mafft:
    input:
        fasta = expand("results/scaffolds/{sample}/ragtag.scaffold.fasta", sample=SAMPLES)
    output:
        "results/alignment/msa.fasta"
    threads: 4
    conda:
        "../envs/phylo.yaml"
    shell:
        """
        mafft --thread {threads} --auto {input.fasta} > {output}
        """

rule iqtree:
    input:
        "results/alignment/msa.fasta"
    output:
        tree = "results/tree/adenovirus.nwk",
        pdf = "results/tree/adenovirus.pdf"
    conda:
        "../envs/phylo.yaml"
    shell:
        """
        iqtree -s {input} -nt AUTO -m MFP -bb 1000 -pre results/tree/adenovirus
        # Convert to PDF using built-in plotting (optional or via another tool)
        """