# workflow/rules/variability.smk

rule compute_entropy:
    input:
        msa = "results/alignment/msa.fasta"
    output:
        tsv = "results/variability/entropy.tsv"
    conda:
        "../envs/phylo.yaml"
    script:
        "../scripts/variability.py"

rule plot_entropy:
    input:
        tsv = "results/variability/entropy.tsv"
    output:
        png = "results/variability/entropy.png"
    conda:
        "../envs/phylo.yaml"
    shell:
        """
        python -c "
import pandas as pd
import matplotlib.pyplot as plt
df = pd.read_csv('{input.tsv}', sep='\\t')
plt.figure(figsize=(12, 4))
plt.plot(df['position'], df['entropy'])
plt.xlabel('Position')
plt.ylabel('Shannon Entropy')
plt.title('Sequence Variability')
plt.savefig('{output.png}')
"
        """