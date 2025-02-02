# 🧬 EdgeR Contrast Analysis for miRNA Expression

📌 Overview

This repository contains R scripts for performing differential miRNA expression analysis using the EdgeR package. The analysis compares different patient groups based on miRNA expression levels, using custom contrast matrices for different conditions.

🔬 Methodology

Data Loading & Preprocessing:

Loads CPM data from Excel files using readxl.

Assumes the first column contains gene/miRNA names.

Converts the data into a numeric matrix.

Group Assignment:

Samples categorized into mild vs. severe, moderate vs. severe, and mild-moderate vs. severe groups.

Mean CPM Calculation:

Computes mean CPM values across samples and groups.

Calculates log fold change for upregulation/downregulation analysis.

EdgeR Differential Expression Analysis:

Creates a DGEList object.

Normalizes data with calcNormFactors.

Constructs a design matrix.

Fits a quasi-likelihood negative binomial generalized log-linear model (glmQLFit).

Tests for differential expression using qlmQLFTest.

Result Extraction & Annotation:

Extracts top differentially expressed miRNAs with topTags.

Computes adjusted p-values (Bonferroni, FDR).

Saves results to an Excel file using openxlsx.

📦 Dependencies

Ensure you have the following R libraries installed:

install.packages(c("readxl", "tibble", "openxlsx"))
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("limma", "edgeR"))

🛠️ Usage

1️⃣ Clone this repository:

git clone https://github.com/claudiacastrillon/EdgeR_Contrast_Analysis.git

2️⃣ Navigate to the project folder:

cd EdgeR_Contrast_Analysis

3️⃣ Run one of the R scripts:

source("contrastmildvsmoderate.r")
source("contrastmildvssevere.r")
source("contrastmildmodvssevere.r")

📊 Output

Excel files with processed miRNA expression contrasts.

Tables of fold changes, log fold changes, and adjusted p-values.

Clustered differential expression analysis based on custom contrasts.

🤝 Contributions

Feel free to contribute by submitting pull requests or reporting issues!

📜 License

This project is open-source. See LICENSE for details.

📩 Contact

For inquiries, contact claudiacastrillon via GitHub. 💡
