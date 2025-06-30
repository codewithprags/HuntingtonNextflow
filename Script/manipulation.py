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