library(tidyverse)
library(readr)

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if an input file was provided
if (length(args) == 0) {
  stop("Please provide an input file name as a command-line argument.")
}

input <- read_csv(args[1])

df <- read_tsv("snpEff.tsv", skip= 5)

keep <- df %>% select('#CHROM', POS, ID, REF, ALT, INFO)
names(keep)[names(keep) == "POS"] <- "pos"
names(keep)[names(keep) == "REF"] <- "ref"
names(keep)[names(keep) == "ALT"] <- "alt"


final <- left_join(keep, input, by= c("ID", "pos", "ref", "alt"))
name <- paste0(unique(df$ID), "_final.csv")
print(name)
write_csv(final, name)