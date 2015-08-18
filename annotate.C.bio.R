#annotate.C.bio = function(x, ...){
library(gridExtra)
library(rtracklayer)
library(stringr)
library(SomaticCancerAlterations)
library(GenomicRanges)
library(ggplot2)
library(ggbio)
library(data.table)
library(plyr)
options(warn = -1)
wd = getwd()
setwd (wd)
annotationwd = paste(wc, "/", "annotation.output", sep = "")
#setwd("C:/Users/vwillia2/Downloads")
#dir.create ("C:/Users/vwillia2/Downloads/annotation.output")
#alleles = read.delim("alleles_IonXpress_003.xls")
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
genelist  = data.frame(unique(oldtnew2[,1]))
dimen = data.frame(dim(genelist))
grows = dimen[1,]
# for (j in 1:grows){
#  id = paste("gene", "_", j, sep = "")
#  assign(id, as.character(genelist[j,1]))
#   }

# query Cbioportal
  require(cgdsr)
  mycgds = CGDS("http://www.cbioportal.org/public-portal/")
  test(mycgds)
# get master list of all cancer studies on website
  mycancerstudies = matrix(getCancerStudies(mycgds)[1:91,1])
# studies = data.frame( grep ("pub", mycancerstudies_all, invert =T))
#get caselists for all studies
  rows = 91
  cases = matrix()
for (i  in 1:91){  
    studylist = (getCaseLists(mycgds, mycancerstudies[i])[,1])
    cases = rbind(cases,studylist)
  }
  cases = cases[2:92,]
  cases = matrix(cases)
  colnames(cases) = "Caselist"
#get genetic profiles for each study/case pairing, focusing on those datasets marked "mutations"
  profiles = matrix()
for (i  in 1:91){  
    prof= getGeneticProfiles(mycgds,mycancerstudies[i])[,1:2]
    studylist = (getCaseLists(mycgds, mycancerstudies[i])[1,1])
    id = match("Mutations", prof[,2], nomatch = 0)
if(id >0){
profid = match("Mutations", as.character(prof[,2]), nomatch =0)
id = (prof[profid,1])
profiles = rbind(profiles,mycancerstudies[i], as.character(id), as.character(studylist))
#dat = getMutationData(mycgds, as.character(studylist), as.character(id), c("BRAF", "KIT", "NRAS", "EGFR", "KRAS", "AKT1", "PIK3CA", "RET"))

dat = getMutationData(mycgds, as.character(studylist), test.3)
write.table(dat, file = "Mutations.txt", sep = "\t", append = T, row.names = F, col.names = F )
}
}

    #plot distribution of variants within each gene
mutations = read.delim("Mutations.txt", header = F)
par(mfrow= c( 4,2))
braf = subset(mutations, mutations[,2] == "BRAF")
braf.count =  (count(braf$V14))
rownames(braf.count) = braf.count[,1]
braf.count = data.matrix(braf.count)
#braf.count.df = data.frame(braf.count)
braf = barplot(braf.count[,2], beside = T, axes = T, cex.names = 0.7, sub = "BRAF")


kit = subset(mutations, mutations[,2] == "KIT")
kit.count =  (count(kit$V14))
rownames(kit.count) = kit.count[,1]
kit.count = data.matrix(kit.count)
kit = barplot(kit.count[,2], beside = T, cex.names = 0.7, sub = "KIT")

nras = subset(mutations, mutations[,2] == "NRAS")
nras.count =  (count(nras$V14))
rownames(nras.count) = nras.count[,1]
nras.count = data.matrix(nras.count)
nras = barplot(nras.count[,2], beside = T, cex.names = 0.7,  sub = "NRAS")

egfr = subset(mutations, mutations[,2] == "EGFR")
egfr.count =  (count(egfr$V14))
rownames(egfr.count) = egfr.count[,1]
egfr.count = data.matrix(egfr.count)
egfr = barplot(egfr.count[,2], beside = T, cex.names = 0.7, sub = "EGFR")


kras = subset(mutations, mutations[,2] == "KRAS")
kras.count =  (count(kras$V14))
rownames(kras.count) = kras.count[,1]
kras.count = data.matrix(kras.count)
kras = barplot(kras.count[,2], beside = T, cex.names = 0.7,sub = "KRAS")


akt1 = subset(mutations, mutations[,2] == "AKT1")
akt.count = (count(akt1$V14))
rownames(akt.count) = akt.count[,1]
akt.count = data.matrix(akt.count)
akt1 = barplot(akt.count[,2], beside = T, cex.names = 0.7, sub = "AKT1")


pik3ca = subset(mutations, mutations[,2] == "PIK3CA")
pik3ca.count =  (count(pik3ca$V14))
rownames(pik3ca.count) = pik3ca.count[,1]
pik3ca.count = data.matrix(pik3ca.count)
pik3ca = barplot(pik3ca.count[,2], beside = T, cex.names = 0.7, sub = "PIK3CA")

