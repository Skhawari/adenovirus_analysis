# workflow/scripts/variability.py

import pandas as pd
from collections import Counter
import math

def shannon_entropy(column):
    freqs = Counter(column)
    total = sum(freqs.values())
    probs = [count / total for count in freqs.values()]
    return -sum(p * math.log2(p) for p in probs if p > 0)

def main(snakemake):
    with open(snakemake.input[0]) as f:
        seqs = [line.strip() for line in f if not line.startswith(">")]
    seqs = list(zip(*seqs))  # transposed: columns = positions
    entropies = [shannon_entropy(col) for col in seqs]
    df = pd.DataFrame({
        "position": list(range(1, len(entropies) + 1)),
        "entropy": entropies
    })
    df.to_csv(snakemake.output[0], sep="\t", index=False)