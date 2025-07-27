import pandas as pd
import gzip


# Read GTF file
gtf_path = "./Data/Reference_genome.gtf"  # your uncompressed GTF
gtf_cols = [
    "seqname", "source", "feature", "start", "end",
    "score", "strand", "frame", "attribute"
]
gtf = pd.read_csv(gtf_path, sep="\t", comment='#', names=gtf_cols)

# Extract gene_id from the attribute column
import re

def extract_gene_id(attr):
    match = re.search(r'gene_id "([^"]+)"', attr)
    return match.group(1) if match else None

gtf['gene_id'] = gtf['attribute'].apply(extract_gene_id)

# Check for duplicates
print("Duplicates:", gtf['gene_id'].duplicated().sum())

# Fix them if needed
def make_unique(ids):
    seen = {}
    result = []
    for i in ids:
        if i not in seen:
            seen[i] = 1
            result.append(i)
        else:
            seen[i] += 1
            result.append(f"{i}.{seen[i]-1}")
    return result

gtf['gene_id_unique'] = make_unique(gtf['gene_id'])

# Replace gene_id in attribute field with the unique version
def replace_gene_id(attr, new_id):
    return re.sub(r'gene_id "([^"]+)"', f'gene_id "{new_id}"', attr)

gtf['attribute'] = [
    replace_gene_id(attr, new_id)
    for attr, new_id in zip(gtf['attribute'], gtf['gene_id_unique'])
]

# Drop helper columns
gtf.drop(['gene_id', 'gene_id_unique'], axis=1, inplace=True)

# Save fixed GTF
fixed_gtf_path = "./Data/Reference_genome.fixed.gtf"
gtf.to_csv(fixed_gtf_path, sep="\t", header=False, index=False, quoting=3)

# Compress to .gtf.gz
with open(fixed_gtf_path, 'rb') as f_in, gzip.open(fixed_gtf_path + ".gz", 'wb') as f_out:
    f_out.writelines(f_in)

print("GTF fixed and saved as:", fixed_gtf_path + ".gz")