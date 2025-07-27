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

./nextflow run nf-core/fetchngs \
--input ~/GSE270472/ids.csv \
--outdir ~/cloud/GSE270472/fetchngs \
--download_method sratools \
--nf_core_pipeline rnaseq \
-w ~/scratch/work/GSE270472/fetchngs \
-profile docker


# Time 1h 46m 18s


./nextflow run nf-core/rnaseq \
--input ~/cloud/GSE270472/fetchngs/samplesheet/samplesheet.csv \
--outdir ~/cloud/GSE270472/alignment_run \
--genome GRCh38 \
--trimmer fastp \
--skip_alignment true \
--pseudo_aligner salmon \
--extra_salmon_quant_args "--gcBias --seqBias" \
--deseq2_vst true \
--save_reference true \
-w ~/scratch/work/GSE270472/alignment_run \
-profile docker -resume
