# INRB-LaBiEp-DENGUE
*This folder contains codes to analyse dengue reads from nanopore platfrom for the outbreak in CHAD*
>*The Pipeline is named DENVAP : Dengue Virus Analysis Pipeline*
## Installation of **DENVAP**
*The installation is very simple but requires some requisites*
>  *1. Conda:*
>> _Linux_
```
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/Miniconda3-latest-Linux-x86_64.sh && \
bash ~/Miniconda3-latest-Linux-x86_64.sh  && \
rm -f ~/Miniconda3-latest-Linux-x86_64.sh
```
>> _MacOS_
```
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/Miniconda3-latest-MacOSX-x86_64.sh && \
bash ~/Miniconda3-latest-MacOSX-x86_64.sh && \
rm -f ~/Miniconda3-latest-MacOSX-x86_64.sh
```
>  *2. Mamba:*
```
conda install -c conda-forge mamba
```
>  *3. DENVAP:*
```
git clone --recursive https://github.com/inrb-labgenpath/INRB-LaBiEp-DENGUE.git
```
```
cd INRB-LaBiEp-DENGUE
chmod u+x {*yaml,*sh,*smk,*.py}
mamba env create -f DENVAP.yaml
```


## Usage
> *1. Load the reads*

- *Load your reads in the fastq folder, make sure your barcode name length is 24 characters*
- *barcode01 ---> XXXXXXXXXXXXXX_barcode01*
- *e.g: barcode01 ---> 23-COG-DENV001_barcode01*
- *Hopefully you may use whatever length you want the next version of the pipeline*

> *2. Run the script*

```
conda activate denvap
```
```
bash --verbose DENVAP.sh
```
> *3. Reset the folder*
*Make sure you save in another folder all the analysis, go to the INRB-LaBiEp-DENGUE location
```
rm -rf ./*
git reset --hard e33ce9964b78710560c2f3bdfee7818f11312cd0
```


