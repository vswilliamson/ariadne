annotate.TCGA = function(x, ...){
library(gridExtra)
library(rtracklayer)
library(stringr)
library(SomaticCancerAlterations)
library(GenomicRanges)
library(ggbio)
library(data.table)
library(plyr)
options( warn = -1)

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

oldtnew = cbind(var.sub[1:2], var[,2])
colnames(oldtnew) = c("chrom", "hg19_loc", "hg38_loc")
oldtnew2 = cbind(var.info, oldtnew[,3])
colnames(oldtnew2) = c("Geneid", "Chrom", "hg19_loc", "ref", "Variant", "Allele.Call", "Type", "Allele.Source", "hg38_loc")

#interface with TCGA
all_datasets = scaListDatasets()
gr = scaLoadDatasets(all_datasets[1:8], merge = TRUE)
meta = elementMetadata(gr)# convertmetadata
df <- data.frame(seqnames=seqnames(gr),
                 starts=start(gr)-1,
                 ends=end(gr),
                 names=c(rep(".", length(gr))),
                 scores=c(rep(".", length(gr))),
                 strands=strand(gr))

TCGA = cbind(df, meta)# join locations to metadata extracted for all studies from df
#id = match(test[1,2], TCGA$starts, nomatch = 0) # query location against TCGA "starts" column. 
#This value must come from hg19 version or the TCGA dataframe must be converted to hg38 format.
fo = matrix(0, nrow = rows, ncol = 10)
for (i in 1:rows){
  id = match(var.sub[i,2], TCGA$starts, nomatch = 0)
  if(id >0){
    info =(TCGA[id,])
    dat = cbind(as.character(info[,1]), as.character(info[,2]), as.character(info[,7]), as.character(info[,9]),as.character(info[,11]), as.character(info[,12]), 
                as.character(info[,13]), as.character(info[,15]), as.character(info[,16]), as.character(info[,20]))
    fo[i,] = dat            
  }else{
  }
}
TCGA = unique(data.frame(subset(fo, fo[,1]  > 0)))
colnames(TCGA) = c("chromosome", "start", "genesymbol", "typemutation", "reference allele", "tumor_seq_allele1", "tumor_seq_allele2", "validation_status", "mutation_status", "dataset")
return(TCGA)
 }
