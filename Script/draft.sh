# ================================ Getting set up ================================ 
sudo apt update

# Install Java
sudo apt install default\-jre # When prompted, enter Y

# Install Nextflow
curl -s https://get.nextflow.io | bash

# Set Java memory limit
# Add to .bashrc directly
echo 'NXF_OPTS="-Xms1g -Xmx4g"' >> ~/.bashrc

# Source .bashrc to apply changes
source ~/.bashrc

###Fetching the Refernce Genome Fasta and FASTQ files### Not really sure if this is the correct file to use
###Manually downloaded the sraruntable.txt file from the NCBI SRA website for the Huntington's disease RNA seq data
##created a sampleids.xlsx file with the sample IDs 

# ================================ Fetching the FASTA and FASTQ files ================================
# ./nextflow run nf-core/rnaseq \
# based on lab, shouldnt this be nf-core/fetchngs  ?
./nextflow run nf-core/fetchngs \
--input ~/HuntingtonNextflow/Data/sampleids.csv \  # Use .csv instead of .xlsx. Also column name should be "sample"?
--outdir ~/HuntingtonNextflow/Data/fetchngs \
--max_cpus 32 --max_memory 128.GB \
--download_method sratools \
--nf_core_pipeline rnaseq \
-w ~/HuntingtonNextflow/Data/fetchngs \
-profile docker

##Prepaing The RNA Seq Pipeline##
# ================================ Indexing the reference genome (no alignment) ================================
./nextflow run nf-core/rnaseq \
# --input ~/HuntingtonNextflow/Data/samplesheet.csv \
# is the input samplesheet from the previous pipe's output?  Data/fetchngs/samplesheet/samplesheet.csv  ?   YES
--input ~/HuntingtonNextflow/Data/fetchngs/samplesheet/samplesheet.csv \
--outdir ~/HuntingtonNextflow/Data/index_run \
--fasta "~/HuntingtonNextflow/Data/Reference_genome_DNAchr4.fa.gz" \
--gtf "~/HuntingtonNextflow/Data/Reference_genome.gtf.gz" \  # ["path to Human HTT refernce geneome,.gtf.gz file type"] \
--skip_alignment --skip_pseudo_alignment \
--trimmer fastp \
--save_reference true \
-w ~/HuntingtonNextflow/Data/index_run \
-profile docker
# =========================== 2. Align the reads (what aligner did the authors use?)
# sequencing instrument model + platform --> based on info, do we need to trim adapters? 

## hisat2, in this pipeline, doesnt actually quantify gene expression --> cant get deseq2 similarity plot. we used it bc star align was our of commission
# DESeq2 = tool to quantify gene expression ; PC plot gives profile 

# Option 1: STAR and Salmon
./nextflow run nf-core/rnaseq \
--input ~/HuntingtonNextflow/Data/fetchngs/samplesheet/samplesheet.csv \
--outdir ~/HuntingtonNextflow/Data/alignment_run \
--fasta "Reference_genome_DNAchr4.fa.gz" \
--gtf "Reference_genome.gtf.gz" \ 
--rsem_index "/HuntingtonNextflow/Data/index_run/genome/rsem" \
--salmon_index "/HuntingtonNextflow/Data/index_run/genome/index/salmon" \
--trimmer fastp \
--pseudo_aligner salmon \
--extra_salmon_quant_args "--gcBias --seqBias" \
--deseq2_vst true \
-w ~/HuntingtonNextflow/Data/alignment_run \
-profile docker

# // OR //
# Option 2: HISAT2 + Salmon
./nextflow run nf-core/rnaseq \
--input ~/HuntingtonNextflow/Data/fetchngs/samplesheet/samplesheet.csv \
--outdir ~/HuntingtonNextflow/Data/alignment_run \
--fasta "~/HuntingtonNextflow/Data/Reference_genome_DNAchr4.fa.gz" \
--gtf "~/HuntingtonNextflow/Data/Reference_genome.gtf.gz" \ 
--salmon_index "~/HuntingtonNextflow/Data/index_run/genome/index/salmon" \
--trimmer fastp \
--aligner hisat2 \
--pseudo_aligner salmon \
--extra_salmon_quant_args "--gcBias --seqBias" \
--deseq2_vst true \
-w ~/HuntingtonNextflow/Data/alignment_run \
-profile docker



# ================================ DEA ================================
# Need to make:
# - Count matrix
# - Contrast file
# - Transcript length matrix

# DESeq2 + GSEA, gProfiler2, and Shiny App
./nextflow run nf-core/differentialabundance \
--input ~/HuntingtonNextflow/Data/differentialabundance/metadata.tsv \
--contrasts ~/HuntingtonNextflow/Data/differentialabundance/contrasts.tsv \
--matrix ~/HuntingtonNextflow/Data/NCBI_DATA/GSE270472_raw_counts_GRCh38.p13_NCBI.tsv.gz \
--transcript_length_matrix ~/HuntingtonNextflow/Data/differentialabundance/transcript_length.tsv \
--gtf ~/HuntingtonNextflow/Data/Reference_genome.gtf.gz \
--filtering_min_proportion 0.3 \        # Filter out genes that are not expressed in at least 30% of samples => prevent noise from genes that are rarely expressed
--filtering_grouping_var condition \    # Contrast variable (condition, or interaction, ..., whichever we specified in the contrast file??)
--deseq2_cores 4 \
--gsea_run true \
--gsea_permute gene_set \               # Use gene set permutation since we have less than 7 samples per group (we only have 3-4)
--gene_sets_files ["two file paths"]    # Gene symbol files? From MSigDB??
--gprofiler2_run true \
--gprofiler2_organism ["organism"] \    # Specify that we're using human genes 
--gprofiler2_sources ["string"] \       # Select specific gene set database (GO, KEGG, REAC...)
--gprofiler2_correction_method gSCS \   # Default for gProfiler, for small gene sets
--shinyngs_build_app true \
--max_cpus 8 --max_memory 8.GB \
--outdir ~/scratch/lab_3/dge_analysis_filtered \
-w ~/scratch/work/lab_3/dge_analysis \
-profile docker # Which package + environmental manager to run the analysis in. We used Docker in the lab.


# # Additional
# # Basic DESeq2 + filtering
# ./nextflow run nf-core/differentialabundance \
# --input ["file_path"] \
# --contrasts ["file_path"] \
# --matrix ["file_path"] \
# --transcript_length_matrix ["file_path"] \
# --gtf ["file_path"] \
# --deseq2_cores 4 \
# --filtering_min_proportion 0.3 \
# --filtering_grouping_var condition \
# --max_cpus 8 --max_memory 8.GB \
# --outdir ~/scratch/lab_3/dge_analysis_filtered \
# -w ~/scratch/work/lab_3/dge_analysis \
# -profile [what profiles do we use here]

# # DESeq2 + GSEA
# ./nextflow run nf-core/differentialabundance \
# --input [file_path] \
# --contrasts [file_path] \
# --matrix [file_path] \
# --transcript_length_matrix [file_path] \
# --gtf [file_path] \
# --filtering_min_proportion 0.3 \
# --filtering_grouping_var condition \
# --deseq2_cores 4 \
# --gsea_run true \
# --gsea_permute [option for small samples] \
# --gene_sets_files [two file paths] \
# --max_cpus 8 --max_memory 8.GB \
# --outdir ~/scratch/lab_3/dge_analysis_filtered \
# -w ~/scratch/work/lab_3/dge_analysis \
# -profile [what profiles do we use here]

