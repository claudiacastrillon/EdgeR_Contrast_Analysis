# Set the geographic location to Madrid, Spain
options(repos = c(CRAN = "https://cran.rediris.es/"))

# Setup and libraries
install.packages("languageserver")
install.packages("readxl")
install.packages("tibble")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::install("limma", force=TRUE)
BiocManager::install("edgeR", force=TRUE)

library(readxl)
library(tibble)
library(limma)
library(edgeR)

# Load data
setwd("~/Downloads")  # Adjust as needed
data <- read_excel("/Users/claudiacastrillonalvarez/Downloads/expression_browsermildvssevere.xlsx")

# Data preparation
data <- as.data.frame(data)
gene_names <- as.character(data[, 1])
if(any(duplicated(gene_names))) {
    stop("Unexpected duplicate gene names found.")
} else {
    rownames(data) <- gene_names
    data <- data[,-1]  # Remove gene names column
}
data <- as.matrix(apply(data, 2, as.numeric))  # Convert data to numeric matrix

# Define conditions
conditions <- factor(c(rep("mild", 10), rep("severe", 10)))

# Calculate mean expressions
mean_mild <- rowMeans(data[, 1:10])
mean_severe <- rowMeans(data[, 11:20])

# Custom fold change calculation
fold_change <- ifelse(mean_mild >= mean_severe, 
                      mean_mild / (mean_severe + 0.1), 
                      - (mean_severe + 0.1) / mean_mild)
log_fold_change <- log2(abs(fold_change)) * sign(fold_change)

# Calculate the average mean expression of CPM values for each gene/miRNA
average_cpm <- rowMeans(data)

# Differential expression analysis with limma
data_log2 <- log2(data + 1)
design <- model.matrix(~ conditions)

# Define contrasts
contrast.matrix <- makeContrasts(MildVsSevere = conditionssevere, levels = design)

v <- voom(data_log2, design, plot=FALSE)
vfit <- lmFit(v, design)
vfit <- contrasts.fit(vfit, contrasts = contrast.matrix)
vfit <- eBayes(vfit)
results <- topTable(vfit, sort.by="P", n=Inf)

# Incorporate custom log fold changes and fold changes into the results
results$logFC <- log_fold_change  # Update the logFC with your custom log fold changes
results$FC <- fold_change  # Add a new column for the non-logarithmic fold changes

# Add average CPM values to the results
results$AverageCPM <- average_cpm

# Create a sequential numeration vector
numeration <- 1:nrow(results)
# Add this numeration as a new column to the 'results' dataframe
results$numeration <- numeration

# Apply Bonferroni adjustment to the original p-values
results$adj.P.Val.Bonferroni <- p.adjust(results$P.Value, method = "bonferroni")

# If you want the numeration to be the first column, you can rearrange the dataframe
results <- results[, c("numeration", setdiff(names(results), "numeration"))]
# Print top 20 results
print(head(results, n = 30))

# Install openxlsx package if not already installed
if (!requireNamespace("openxlsx", quietly = TRUE)) {
    install.packages("openxlsx")
}

# Load the openxlsx library
library(openxlsx)

# Specify the file path where you want to save the Excel file
# Adjust the path and filename as needed
file_path <- "/Users/claudiacastrillonalvarez/Downloads/comparacion_CPM_mild_vs_severe.xlsx"

# Export the results dataframe to an Excel file
write.xlsx(results, file = file_path)

# Print a message to indicate that the file has been saved successfully
cat("Results have been exported to:", file_path)

