annotate.PharmaGKB = function (vars, env = .GlobalEnv) {
  library("httr")
  library("XML")
  library(rtracklayer)
  #setup current working directory from which to run function
  setwd("C:/Users/vwillia2/Downloads")
  wd = getwd()
  annotdir = paste(wd,"/", "annotation.output", sep ="")
  variants = vars
  
  #access Torrent output file
  print ("Searching PharmaGKB")
  print(dim(variants))
  var.info = cbind(variants[,13], variants[,1:5], variants[,10:11])
  var.sub = cbind(variants[,1:2], (variants[,2]+1))
  colnames(var.sub) = c("chr", "start", "end")
  var.sub.gr  = makeGRangesFromDataFrame(var.sub)
  ch = import.chain("hg19ToHg38.over.chain")
  var.sub.gr.new = liftOver(var.sub.gr, ch)
  var.sub.gr.new  = as.data.frame(var.sub.gr.new) # variants converted.... don't forget to check for discrepancy
  var = var.sub.gr.new[,3:5]
  colnames(var) = c("chr_name", "start", "end")
  oldtnew = cbind(var.sub[1:2], var[,2])
  colnames(oldtnew) = c("chrom", "hg19_loc", "hg38_loc")
  oldtnew2 = cbind(var.info, oldtnew[,3])
  colnames(oldtnew2) = c("Geneid", "Chrom", "hg19_loc", "ref", "Variant", "Allele.Call", "Type", "Allele.Source", "hg38_loc")
  genelist = data.frame (oldtnew2[,1])
  
  # match genesymbols to PAIDs in #pharmagkb.id2gene
  pharma = read.delim("pharmagkb.id2gene.txt", header = F)
  genelength = dim(genelist)[1]
  setwd(annotdir)
  for (i in 1:genelength){
    gene = as.character(genelist[i,])
    loc = grep(gene, pharma[,2])
    id = pharma[loc,1]
    
  # Define certificate file to pull gene specific information from PharmaGKB
  #Read file in two ways: 1) as poorly formatted table using readHTMLTable, 2) download all information in text form and 
  #extract from output. Will Only download gene information once regardless of how many times reported in output. 
  # method - 1  
  cafile <- system.file("CurlSSL", "cacert.pem", package = "RCurl")
  pathloc = paste("gene/", id, sep = "")
  page = GET(
    "https://www.pharmgkb.org/",
    path = pathloc,
    query="tabType=tabGenetics#tabview=tab1&subtab=",
    config(cainfo = cafile)
  )
  x = content(page, "text", "\n")
  tab <- sub('.*(<table class="grid".*?>.*</table>).*', '\\1', x)
  # Parse the table
  results = readHTMLTable(tab)
  
  #method - 2
  site = "https://www.pharmgkb.org/gene/"
  query = "?tabType=tabGenetics#tabview=tab1&subtab="
  htmlloc = paste("https://www.pharmgkb.org/", pathloc, "?tabType=tabGenetics#tabview=tab1&subtab=", sep = "")
  print (htmlloc)
  resultsloc = paste(annotdir, "/", id, gene, ".txt", sep = "")
  #print (page)
  # Use regex to extract the desired table
 
  download.file(htmlloc, resultsloc)

              }
}
# notes 
#grep ("<!-- Names -->", PIK3CA)
#grep ("<!-- Variant", PIK3CA)
#grep ("<!-- Drugs -->", PIK3CA)
#grep ("<!-- Variation -->", PIK3CA)

sub(".*?GN=(.*?);.*", "\\1", a)
sub(".*?GN=(.*?)(;.*|$)", "\\1", a)



