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
# condition_control_treated_blockrep,condition,control,treated,replicate;batch

contrasts = pd.DataFrame()
contrasts['id'] = ''
contrasts['variable'] = ''
contrasts['reference']= '' # smaplesheet something ?? 
contrasts['target'] = ''
targets = np.where(df['genotype']=='mutant')
contrasts['target'][targets]= df['genotype']
contrasts['blocking']= ''
contrasts['id'] = contrasts['variable']+'_'+contrasts['reference']+'_'+contrasts['target']+'_'+contrasts['blocking']

print(contrasts)