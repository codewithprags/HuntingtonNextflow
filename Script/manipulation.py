import pandas as pd
import gzip
import numpy as np

# New Spreadsheet
sra=pd.read_csv("./Data/SraRunTable.csv")
print(sra.head())

df = pd.DataFrame()
# cols sample,fastq_1,fastq_2,condition,time,interaction,replicate
# HD == huntington disease, HTT = huntingtin gene//protein
# 4 KO, 4 HD, 3 control 
df['sample'] = sra[["Run"]]
df["fastq_1"] = ''
df["fastq_2"] = ''  
df["genotype"]= sra[["genotype"]]
df['condition'] = 'control'
locations = np.where(df['genotype'] != 'control')
df["condition"][locations] = 'mutant' 
df['interaction'] = ''
df["treatment"] = sra[["treatment"]]
df['replicate'] = ('1', '2', '3', '4', '1', '2', '3', '4', '1', '2', '3')

print(df)

# Contrasts
# id,variable,reference,target,blocking
# condition_control_treated,condition,control,treated,

# Control (IC1): nH105IC1, nH105IC2, nH105IC3, nH105IC4
# Huntington's Disease (HD/ND4222): nH222HD1, nH222HD2, nH222HD3, nH222HD4
# HTT knock out (HTT-KO): nH37KO1, nH37KO2, nH37KO3
# idk where to relate these ^^ to sra bc sra doenst use these IDs specifically 

# contrasts = pd.DataFrame()
# contrasts['id'] = ''
# contrasts['variable'] = ''
# contrasts['reference']= '' # smaplesheet something ?? 
# contrasts['target'] = ''
# targets = np.where(df['genotype']=='mutant')
# contrasts['target'][targets]= df['genotype']
# contrasts['blocking']= ''
# contrasts['id'] = contrasts['variable']+'_'+contrasts['reference']+'_'+contrasts['target']+'_'+contrasts['blocking']

contrasts = pd.DataFrame({
    'id': ['condition_control_vs_HTT-KO', 'condition_control_vs_HD'],
    'variable': ['condition']*2,
    'reference': ['control']*2,
    'target': ['HTT_KO', 'HD'],
    'blocking': ['']*2  # no blocking
})

print(contrasts)

# Save the DataFrame to a CSV file
df.to_csv("./Data/differentialabundance/metadata.tsv", sep='\t', index=False)
contrasts.to_csv("./Data/differentialabundance/contrasts.tsv", sep='\t',index=False)


# Make transcript lengths DataFrame
transcript_lengths_raw = pd.read_csv("./Data/GSE270472_HD_KO_NSC.csv")

# Problem: This files has multiple transcript IDs in a single cell, so we need to expand it.
# The IDs are separated by commas and each ID has an associated weight, which we will ignore (for now).
# Prepare list to store rows
expanded_rows = []

# Iterate over rows
for _, row in transcript_lengths_raw.iterrows():
    transcript_field = row["transcript_id(s)"]
    length = row["length"]
    
    # Split the transcript list by comma
    items = transcript_field.split(',')
    
    # Get every other item (transcript IDs, skipping weights)
    transcript_ids = items[::2]
    
    # Store each transcript ID with the shared length
    for tid in transcript_ids:
        expanded_rows.append([tid.strip(), float(length)])

# Create the clean DataFrame
transcript_lengths = pd.DataFrame(expanded_rows, columns=["transcript_id", "transcript_length"])

print(transcript_lengths.head())
transcript_lengths.to_csv("./Data/differentialabundance/transcript_length.tsv", sep='\t', index=False)
