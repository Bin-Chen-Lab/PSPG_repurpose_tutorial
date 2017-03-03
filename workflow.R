#this pipeline is a simple version of predicting drug hits for a given disease
#to get started, you need to select one disease and find one dataset from GEO that includes both case (disease) and control (healthy/non-tumor) samples
#depending the question you are asking, you can also compare responders vs non-responders, mutation vs wild type, etc.

setwd("~/Documents/stanford/hcc/PSPG_repurpose_tutorial/data/")

#insall packages before running the code
#source("http://www.bioconductor.org/biocLite.R")
#biocLite("impute")
#biocLite("siggenes")
#biocLite("RankProd")
#biocLite("preprocessCore")
#biocLite("GEOQuery")
#biocLite("qvalue")

#installed.packages(c("pheatmap", "gplots", "ggplot2", "RColorBrewer", "plyr"))

###############################
#parameters
disease <- "liver" #no space

#method to compute disease signatures. by default, we use SAM.
method_id <- 3 #2: rankprod, 3: siggenes sam, 

q_thresh <- 0.05 #fdr; may loose the threshold if there are no differentially expressed genes
fold_change <- 1 #fold change cutoff

#disease signature file
dz_sig.file <- paste(disease, "/dz_signature_cmap.txt", sep="") #paste(GSE, "_dz_sig_",method_id,".txt",sep="")
###############################

#create a folder for the diseaes
if (!dir.exists(disease)) dir.create(disease)

#create disease signatures
#need to identify a dataset used to create disease signatures;
#need to find regular expression to extract case and control samples from sample titles
#in the real case, you need to find a more robust to validate disease signatures before making drug predictions.
#uncomment the following lines to build your own signatures. Otherwise, we will use the example signatures

GSE <- "GSE25097"
case_reg <- "tumor sample"
control_reg <- "non_tumor"
source("../code/create_dz_signature_from_GEO.R")


#predict  drugs using connectivity map data
cmd <- paste("Rscript ../code/predict_drugs_cmap.R", disease, "cmap", paste(disease, "/dz_signature_cmap.txt", sep=""))
system(cmd)

#analyze predictions
source("../code/drug_repurpose.R")

#all the results will be stored in the disease folder
