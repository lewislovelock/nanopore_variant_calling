#!/bin/bash

# Function for displaying usage information
usage() {
    echo "Usage: $0 <FASTQ_FILE> <REF_FILE> <OUTPUT_DIR>"
    echo "FASTQ_FILE: Path to the input FASTQ file"
    echo "REF_FILE: Path to the reference genome file"
    echo "OUTPUT_DIR: Directory where the output will be saved"
}

# Check for -h or --help argument for usage
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    exit 0
fi

# Check if the correct number of arguments was provided
if [ "$#" -ne 3 ]; then
    usage
    exit 1
fi

# Configurable arguments
FASTQ_FILE=$1
REF_FILE=$2
OUTPUT_DIR=$3

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Function for logging
log() {
    echo "[`date`] $1"
}

log "Starting pipeline"

# Quality control with NanoPlot
if [ ! -f $OUTPUT_DIR/NanoPlot/NanoStats.txt ]; then
    log "Running NanoPlot for quality control"
    NanoPlot --fastq $FASTQ_FILE --outdir $OUTPUT_DIR/NanoPlot
else
    log "NanoPlot output already exists, skipping"
fi

# Mapping with minimap2
if [ ! -f $OUTPUT_DIR/aligned.sam ]; then
    log "Running minimap2 for mapping"
    minimap2 -ax map-ont $REF_FILE $FASTQ_FILE > $OUTPUT_DIR/aligned_temp.sam
    if [ $? -eq 0 ]; then
        mv $OUTPUT_DIR/aligned_temp.sam $OUTPUT_DIR/aligned.sam
    fi
else
    log "Aligned SAM file already exists, skipping"
fi

# Sorting and indexing with samtools
if [ ! -f $OUTPUT_DIR/aligned_sorted.bam ]; then
    log "Sorting and indexing with samtools"
    samtools sort $OUTPUT_DIR/aligned.sam > $OUTPUT_DIR/aligned_sorted_temp.bam
    if [ $? -eq 0 ]; then
        mv $OUTPUT_DIR/aligned_sorted_temp.bam $OUTPUT_DIR/aligned_sorted.bam
        samtools index $OUTPUT_DIR/aligned_sorted.bam
    fi
else
    log "Sorted BAM file already exists, skipping"
fi

# Variant calling with longshot
if [ ! -f $OUTPUT_DIR/variants.vcf ]; then
    log "Running longshot for variant calling"
    longshot --bam $OUTPUT_DIR/aligned_sorted.bam --ref $REF_FILE --out $OUTPUT_DIR/variants_temp.vcf
    if [ $? -eq 0 ]; then
        mv $OUTPUT_DIR/variants_temp.vcf $OUTPUT_DIR/variants.vcf
    fi
else
    log "Variants VCF file already exists, skipping"
fi

# Structural variant detection with sniffles
if [ ! -f $OUTPUT_DIR/structural_variants.vcf ]; then
    log "Running sniffles for structural variant detection"
    sniffles -i $OUTPUT_DIR/aligned_sorted.bam -v $OUTPUT_DIR/structural_variants_temp.vcf
    if [ $? -eq 0 ]; then
        mv $OUTPUT_DIR/structural_variants_temp.vcf $OUTPUT_DIR/structural_variants.vcf
    fi
else
    log "Structural variants VCF file already exists, skipping"
fi

log "Pipeline completed successfully."

