annotate.ClinVar = function(x, ...){
library(gridExtra)
library(rtracklayer)
library(stringr)
library(SomaticCancerAlterations)
library(GenomicRanges)
library(ggbio)
library(data.table)
library(plyr)
options(warn = -1)

)

#alleles = read.delim(x)
variants = subset(alleles, alleles$Allele.Call != "No Call")
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

write.table("Variant locations, somatic", file = "C:/Users/vwillia2/Downloads/annotation.output/Coordinates.txt", append = T, col.names = F, row.names = F)
write.table(oldtnew, file = "C:/Users/vwillia2/Downloads/annotation.output/Coordinates.txt", append = T, sep = "\t", col.names = F, row.names = F)

#annotate using GRCH clinvar.somatic
clinvar = read.delim("clinvar.GRch38.somatic.txt", header = F)
colnames(clinvar) = c("AlleleID", "Type", "Name", "GeneID", "GeneSymbol", "ClinicalSignificance", "RS# (dbsnp)", "nsv (dbVar)", "RCVaccession", "TestedinGTR", "PhenotypeIDs", "Origin", "Assembly",
                      "Chromosome", "Start", "Stop", "Cytogenetic", "ReviewStatus", "HGVS(c.)", "HGVS(p.)", "NumberSubmitters", "LastEvaluated", "Guidelines", "OtherIDs", "VariantID", "Reference Allele", 
                      "AlternateAllele", "SubmitterCategories")


fo = matrix(0, nrow = rows, ncol = 14)
for (i in 1:rows){
  id = match(var[i,2], clinvar[,15], nomatch = 0)
  if(id >0){
    info =(clinvar[id,])
    dat = cbind(as.character(info[,3]), as.character(info[,5]), as.character(info[,6]), as.character(info[,7]),as.character(info[,11]), as.character(info[,12]), as.character(info[,14]), 
                as.character(info[,15]), as.character(info[,17]), as.character(info[,19]),as.character(info[,20]), as.character(info[,24]), as.character(info[,26]), as.character(info[,27]))
    fo[i,] = dat
   
  }else{
    
  }
}

CLINVAR= unique(data.frame(subset(fo, fo[,1]  > 0)))
colnames(CLINVAR) = c("name", "gene symbol", "clinical significance", "rs#", "phenotype", "origin", "chromosome", "start", "cytogenetic", "HGVS (coding)", "HGVS (protein)",  "other ids", "reference allele", "alternate allele")
return(CLINVAR)

}

