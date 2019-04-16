# Instructions to reconstruct the analysis in the *baerhunter* manuscript

## Introduction
Baerhunter is an R package for identifying and quantifying intergenic non-coding (small RNA and UTR) elements in bacterial genomes from directional (stranded) RNA-seq data. The R markdown scripts in this repository reconstruct the analysis presented in the *baerhunter* manuscript [Ozuna et al.]. The html output produced by knitr for each script is also provided. Below are instructions for running these scripts.

## Setup
Create a local directory where the input and output files can be stored. We will assume here this directory has been created and will refer to it as the "project" directory. Under the *project* directory, create a directory called *docs* and download in it all .Rmd scripts from the docs directory in this repository (alternatively, simply clone this repository into a repository on your local computer).

All scripts here require some data to work with. The data is too large to be part of this repository and it is stored instead at the Birkbeck Data Repository (BiRD, https://researchdata.bbk.ac.uk). Download the file data_dir.tar.gz from BiRD and unpack it in the project directory:
```{bash }
tar zxvf data_dir.tar.gz
```
This should create a directory called *data* containing all data files needed for running the scripts below.

## Simulating an RNA-seq dataset
### The `simulation.Rmd` script
The simulated data presented in the *baerhunter* manuscript can be reconstructed with the `simulation.Rmd` script. If the *data* directory has been unpacked properly, this script can be uploaded into Rstudio and run with `knitr` to simulate the reads produced in an artificial RNA-seq experiment (10 samples, 5 in one of two conditions) as described in the manuscript. All output will be under the newly created directory *output*. 

If you would rather skip running this script, you can download the output from the same BiRD repository (file: *output_from_simulation.rmd.tar.gz*). You will need to unpack this file in the project directory in order to continue to the next step.
```{bash }
tar zxvf output_from_simulation.rmd.tar.gz
```

## Running baerhunter on the simulated data
### The `example_run_simulations.Rmd` script
Here, we assume that the simulated data has already been produced and is located in the right directory structure (see previous step). It is also assumed that the *data* directory and its contents have been unpacked.

You will need the following additional files  to run this script:

* Two directories containing the predictions of Rockhopper for the simulated data (these are used for comparison to baerhunter and are not necessary for the baerhunter runs). Download the data from BiRD (simulations directory):
   + rockhopper_fastq_0.2_40_output.tar.gz
   + rockhopper_fastq_0.5_40_output.tar.gz
Unpack the archives in the local directory:
`output/simulations/paired_realistic_selected_sRNA_UTR/fc.20`
(this directory should already exist under the project directory, if the instructions above have been followed).

* The final `conditions.txt` should be downloaded from BiRD/simulations and copied to the same directory (output/simulations/paired_realistic_selected_sRNA_UTR/fc.20)

If all the above is in place, the script `example_run_simulations.Rmd` should run to completion, producing a number of files, including bam files containing the mapped reads, gff3 files augmented with the new annotated features and directories with counts for all features.

Again, if you prefer not to run the script, all output can be obtained from BiRD (file: `output_example_run_simulations_rmd.tar.gz`).

## Running baerhunter on real data (E-MTAB-1616)
### The `example_run_realdata*.Rmd` scripts
The second part of the analysis involves running baerhunter on a real RNA-seq dataset (ArrayExpress E-MTAB-1616) and comparing the results to Rockhopper runs.


There are two scripts to run here. One, `example_run_realdata.Rmd`,  runs *baerhunter* for one choice of parameters (5-10) and is more concise and so more suitable for viewing; the other, `example_run_realdata_mult_cutoffs.Rmd`,  runs baerhunter for different combinations of cut-offs, thus including a lot of repetition in the calls to functions etc. The latter script is needed to reproduce all figures in the *baerhunter* manuscript.

Both scripts require some files/directories to exist to run to completion. To set this up properly, download the file: `required_for_realdata_run.tar.gz` from
BiRD/real_data and unpack it in the project directory:
```{bash }
tar zxvf required_for_realdata_run.tar.gz
```

It is also assumed that the *data* directory and its contents are also present in the project directory.

After this, you should be able to run the script with *knitr* and produce the corresponding *html* files.

If you do not wish to run the scripts but would like to see all output files, you can download the following file from BiRD/real_data:
`output_example_run_realdata_mult_cutoffs_rmd.tar.gz`
and unpack it locally for examination.

## Reference
A. Ozuna, D. Liberto, R. M. Joyce, K.B. Arnvig, I. Nobeli. baerhunter: An R package for the discovery and analysis of expressed non-coding regions in bacterial RNA-seq data.

