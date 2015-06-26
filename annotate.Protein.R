calculateProtein = function(x){
library(rtracklayer)
library(stringr)
library(GenomicRanges)
library(ggbio)
library(plyr)
library(rfPred)
library(gdata)
options(warn = -1)
setwd("C:/Users/vwillia2/Downloads")
dir.create ("C:/Users/vwillia2/Downloads/annotation.output")
#alleles = read.xls(x, sheet = 1)
#alleles = read.delim(x)
#variants = subset(alleles, alleles$Allele.Call != "No Call")

var.info = cbind(variants[,13], variants[,1:5], variants[,10:11])
var.sub = cbind(variants[,1:2], (variants[,2]+1))
colnames(var.sub) = c("chr", "start", "end")
var.sub.gr  = makeGRangesFromDataFrame(var.sub)
ch = import.chain("hg19ToHg38.over.chain")
var.sub.gr.new = liftOver(var.sub.gr, ch)
var.sub.gr.new  = as.data.frame(var.sub.gr.new) # variants converted.... don't forget to check for discrepancy
var = var.sub.gr.new[,3:5]  
dimen = data.frame(dim(var))
rows = dimen[1,]
colnames(var) = c("chr_name", "start", "end")
var.pred.3 = cbind(variants[,1:4])
id = data.frame(sub("chr","", var.pred.3[,1]))
var.pred = cbind(id,var.pred.3[,2:4])
colnames(var.pred) = c("chr", "pos", "ref", "alt")
result = rfPred_scores(variant_list = var.pred, data = "http://www.sbim.fr/rfPred/all_chr_rfPred.txtz", index="http://www.sbim.fr/rfPred/all_chr_rfPred.txtz.tbi")
fin = subset(result, result$aapos != "no matching")

#write.table("Protein Effect", file = "C:/Users/vwillia2/Downloads/annotation.output/ProteinEffect.txt", sep= "\t", append = T, col.names = F, row.names = F)
write.table(fin, file = "C:/Users/vwillia2/Downloads/annotation.output/ProteinEffect.txt", append = T, sep  = "\t", col.names = F, row.names = F)

stuff = read.delim("C:/Users/vwillia2/Downloads/annotation.output/ProteinEffect.txt", header = F)
colnames(stuff) = c("Chromosome", "position_hg19", "reference", "alteration", "protein", "aaref", "aalt", "aapos", "rsPred_score", 
                    "SIFT_score", "PolyPhen2_score", "MutationTaster_score", "PhyloP_score", "LRT_score")
file.remove("C:/Users/vwillia2/Downloads/annotation.output/ProteinEffect.txt")

return(stuff)
}
