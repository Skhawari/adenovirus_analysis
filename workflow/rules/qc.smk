# workflow/rules/qc.smk

import pandas as pd
samples = pd.read_csv(config["samples"], sep="\t", index_col="sample")

rule fastp:
    input:
        fq1 = lambda wc: samples.loc[wc.sample, "fq1"],
        fq2 = lambda wc: samples.loc[wc.sample, "fq2"]
    output:
        fq1 = "results/trimmed/{sample}_1.fq.gz",
        fq2 = "results/trimmed/{sample}_2.fq.gz",
        html = "results/qc/{sample}_fastp.html",
        json = "results/qc/{sample}_fastp.json"
    log:
        "results/qc/{sample}_fastp.log"
    threads: 4
    conda:
        "../envs/qc.yaml"
    shell:
        """
        fastp -i {input.fq1} -I {input.fq2} \
              -o {output.fq1} -O {output.fq2} \
              -h {output.html} -j {output.json} \
              -w {threads} &> {log}
        """

rule multiqc:
    input:
        expand("results/qc/{sample}_fastp.json", sample=samples.index)
    output:
        "results/qc/multiqc_report.html"
    conda:
        "../envs/qc.yaml"
    shell:
        "multiqc results/qc -o results/qc"