#  list of genes returned from 'non unique row.names' error
dups = ["AC159540.1", "AKAP17A", "ASMT", "ASMTL", "ASMTL-AS1", "C1R", "CAPN8", "CD99", "CD99P1", "CRLF2", "CSF2RA", "DHRSX", "ECSCR", "GALNT9", "GRK1", "GTPBP6", "IL3RA", "IL9R", "LINC00102", "LINC00623", "LINC00684", "LINC00685", "LOC100996792", "LOC101928055", "LOC101928070", "MID1", "MIR3690", "MIR6089-1", "P2RY8", "PLCXD1", "PPP2R3B", "RP11-475O6.1", "RP11-513O17.2", "RP11-69H14.6", "RP4-669L17.10", "RP5-1043L13.1", "SHOX", "SLC25A6", "SPRY3", "TRNAA-AGC", "TRNAA20", "TRNAE-UUC", "TRNAG-CCC", "TRNAN-GUU", "TRNAV-CAC", "VAMP7", "ZBED1"]

import pandas as pd

# Load your files
counts = pd.read_csv("./Data/salmon.merged.gene_counts.tsv", sep="\t")

# Check for duplicates
print("Counts duplicates:", counts['gene_name'].duplicated().sum())
counts["gene_name"] = counts["gene_id"]
print("Counts duplicates:", counts['gene_name'].duplicated().sum())

# Save the cleaned files
counts.to_csv("./Data/salmon.merged.gene_counts.fixed.tsv", sep="\t", index=False)

