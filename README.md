# HuntingtonNextflow
This study investigates early transcriptional dysregulation resulting from loss or mutation of the HTT gene, the causative factor in Huntington disease (HD). \
Using RNA-seq data from iPSC-derived neurons representing wild-type, HTT knockout (HTT-KO), and HD mutant conditions, we performed differential gene expression and pathway enrichment analyses. Both HTT-KO and HD models exhibited significant upregulation of genes involved in neural development, inflammation, and extracellular matrix remodeling, with shared overexpression of PAX3 and BGN. Gene Ontology and GSEA revealed overlapping enrichment in structural and cancer-related pathways, though HTT-KO showed more pronounced alterations. 

Sample groups are shown in SraRunTable.csv and GSE270472_HD_KO_NSC.xlsx:
- Control (IC1):                    nH105IC1, nH105IC2, nH105IC3, nH105IC4
- Huntington's Disease (HD/ND4222): nH222HD1, nH222HD2, nH222HD3, nH222HD4
- HTT knock out (HTT-KO):           nH37KO1, nH37KO2, nH37KO3

Resources: 
- nf-core/fetchngs: https://nf-co.re/fetchngs/1.12.0/
- nf-core/rnaseq: https://nf-co.re/rnaseq/3.19.0
- nf-core/differentialabundance: https://nf-co.re/differentialabundance/1.5.0
