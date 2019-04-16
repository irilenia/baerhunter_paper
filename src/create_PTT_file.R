prot_data <- read.delim("GCA_000195955.2_ASM19595v2_feature_table.txt", sep = "\t", header = TRUE)
cds_data <- prot_data[prot_data$X..feature=="CDS",]
location <- paste(cds_data$start, "..", cds_data$end, sep = "")
ptt_tab <- data.frame(location, cds_data$strand, cds_data$product_length, cds_data$product_accession, rep("-", length(location)), cds_data$locus_tag, rep("-", length(location)), rep("-", length(location)), cds_data$name)
colnames(ptt_tab) <- c("Location", "Strand", "Length", "PID", "Gene", "Synonym", "Code", "COG", "Product")
write.table(ptt_tab, "AL123456.ptt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE, append = TRUE)
