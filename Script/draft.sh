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
###Fetching the Frefernce Genome Fasta and FASTQ files### Not really sure if this is the correct file to use

# ================================ Fetching the FASTA and FASTQ files ================================
./nextflow run nf-core/rnaseq \
--input ~/HuntingtonNextflow/Data/sampleids.xlsx \
--outdir ~/HuntingtonNextflow/Data/fetchngs \
--max_cpus 32 --max_memory 128.GB \
--download_method sratools \
--nf_core_pipeline rnaseq \
-w ~/HuntingtonNextflow/Data/fetchngs \
-profile docker

##Prepaing The RNA Seq Pipeline##
# ================================ Indexing the reference genome ================================
./nextflow run nf-core/rnaseq \
--input ~/HuntingtonNextflow/Data/samplesheet.csv \
--outdir ~/HuntingtonNextflow/Data/index_run \
--fasta ["path to Human HTT refernce geneome,.fa.gz file type"] \
--gtf ["path to Human HTT refernce geneome,.gtf.gz file type"] \
--skip_alignment --skip_pseudo_alignment \
--trimmer fastp \
--save_reference true \
-w ~/HuntingtonNextflow/Data/index_run \
-profile docker
# Or
./nextflow run nf-core/rnaseq \
--input ~/scratch/lab_2/fetchngs/samplesheet/samplesheet.csv \
--outdir ~/scratch/lab_2/alignment_run \
--fasta ~/labs/lab_2/reference_genome/dmel/Drosophila_melanogaster.BDGP6.46.dna_sm.toplevel.fa.gz \
--gtf ~/labs/lab_2/reference_genome/dmel/Drosophila_melanogaster.BDGP6.46.113.gtf.gz \
--salmon_index "/home/user/scratch/lab_2/index_run/genome/index/salmon" \
--trimmer fastp \
--aligner hisat2 \
--pseudo_aligner salmon \
--extra_salmon_quant_args "--gcBias --seqBias" \
--deseq2_vst true \
-w ~/scratch/work/lab_2/alignment_run \
-profile docker


# ================================ DEA ================================
./nextflow run nf-core/differentialabundance \
--input [file_path] \
--contrasts [file_path] \
--matrix [file_path] \
--transcript_length_matrix [file_path] \
--gtf [file_path] \
--deseq2_cores 4 \
--filtering_min_proportion 0.3 \
--filtering_grouping_var condition \
--max_cpus 8 --max_memory 8.GB \
--outdir ~/scratch/lab_3/dge_analysis_filtered \
-w ~/scratch/work/lab_3/dge_analysis \
-profile [what profiles do we use here]


./nextflow run nf-core/differentialabundance \
--input [file_path] \
--contrasts [file_path] \
--matrix [file_path] \
--transcript_length_matrix [file_path] \
--gtf [file_path] \
--filtering_min_proportion 0.3 \
--filtering_grouping_var condition \
--deseq2_cores 4 \
--gsea_run true \
--gsea_permute [option for small samples] \
--gene_sets_files [two file paths] \
--max_cpus 8 --max_memory 8.GB \
--outdir ~/scratch/lab_3/dge_analysis_filtered \
-w ~/scratch/work/lab_3/dge_analysis \
-profile [what profiles do we use here]


./nextflow run nf-core/differentialabundance \
--input [file_path] \
--contrasts [file_path] \
--matrix [file_path] \
--transcript_length_matrix [file_path] \
--gtf [file_path] \
--filtering_min_proportion 0.3 \
--filtering_grouping_var condition \
--deseq2_cores 4 \
--gsea_run true \
--gsea_permute gene_set \
--gene_sets_files [two file paths]
--gprofiler2_run true \
--gprofiler2_organism [organism] \
--gprofiler2_sources [string] \
--gprofiler2_correction_method gSCS \
--shinyngs_build_app true \
--max_cpus 8 --max_memory 8.GB \
--outdir ~/scratch/lab_3/dge_analysis_filtered \
-w ~/scratch/work/lab_3/dge_analysis \
-profile [what profiles do we use here]