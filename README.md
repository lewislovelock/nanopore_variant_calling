# Nanopore Variant Calling

This repository contains a script for performing variant calling using Nanopore sequencing data.

## Prerequisites

Before running the script, make sure you have the following software installed:

* [NanoPlot](https://github.com/wdecoster/NanoPlot)
* [Minimap2](https://github.com/lh3/minimap2)
* [Samtools](https://github.com/samtools/samtools)
* [Longshot](https://github.com/pjedge/longshot)
* [Sniffles](https://github.com/fritzsedlazeck/Sniffles)

## Usage

To run the variant calling script, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/nanopore_variant_calling.git
    ```

2. Navigate to the repository directory:

    ```bash
    cd nanopore_variant_calling/pipeline
    ```

3. Run the script:

    ```bash
    ./nanopore_variant_calling.sh 
    ```

    It will print the usage:

    ```bash
    Usage: ./nanopore_variant_calling.sh <FASTQ_FILE> <REF_FILE> <OUTPUT_DIR>
    FASTQ_FILE: Path to the input FASTQ file
    REF_FILE: Path to the reference genome file
    OUTPUT_DIR: Directory where the output will be saved
    ```

## Output

The script will generate the following output files:

* `NanoPlot/`: Directory containing the output of NanoPlot, which includes various plots and statistics about the quality of the sequencing data.
* `aligned.sam`: SAM file containing the aligned reads.
* `aligned_sorted.bam`: BAM file containing the sorted and indexed aligned reads.
* `aligned_sorted.bam.bai`: Index file for the `aligned_sorted.bam` file.
* `variants.vcf`: VCF file containing the detected small variants.
* `structural_variants.vcf`: VCF file containing the detected structural variants.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).