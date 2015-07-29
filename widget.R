require(tcltk)
tclRequire("BWidget")
tt <- tktoplevel(background = "light blue", width = 600, height = 600)
tkpack.propagate(tt,FALSE)



require("xlsxjars")
require("xlsx")
require("grid")
wd = getwd()
setwd (wd)
tktitle(tt) = "Annotate Ion Torrent Variants"
tkgrid(
   tklabel(
     tt,text = "Generate variant annotation", font = "Bold", background = "light blue"
   ),columnspan = 10, pady = 10
 )

# Function 1
getfile <- function() {
  name <-
    tclvalue(tkgetOpenFile(filetypes = "{{XLS Files} {.xls}} {{All files} *}"))
  if (name == "")
    return;
  #tt$env$datafile <- read.delim(name, header = T)
  print (name)
  Tordata = read.delim(name, header = T)
  assign("myData", Tordata, envir = .GlobalEnv)
}

# callback that plots QC values for NoCalls and Calls
#function 2
dosomething <- function(tt) {
  png("Types.png")
  attach(myData)
  par(mfrow = c(1,3))
  plot(myData$Type, col = rainbow(4), main = "Types of Variants-All")
  Calls = subset(myData, myData$Allele.Call != "No Call")
  NoCalls = subset(myData, myData$Allele.Call == "No Call")
  plot(Calls$Type, col = rainbow(4), main = "Types of Variants - Calls")
  plot(NoCalls$Type, col = rainbow(4), main = "Types of variants - No Calls")
  dev.off()
  Calls.vars = cbind(
    as.character(Calls$Chrom), as.numeric(Calls$Position), as.character(Calls$Ref), as.character(Calls$Allele.Call), as.character(Calls$Variant), Calls$Frequency, Calls$Quality, Calls$Coverage, Calls$Strand.Bias
  )
  NoCalls.vars = cbind(
    as.character(NoCalls$Chrom), as.numeric(Calls$Position), as.character(NoCalls$Ref), as.character(NoCalls$Allele.Call), as.character(NoCalls$Variant), NoCalls$Frequency, NoCalls$Quality, NoCalls$Coverage, NoCalls$Strand.Bias
  )
  AllCalls.vars = cbind(
    as.character(myData$Chrom), as.numeric(Calls$Position), as.character(myData$Ref), as.character(myData$Allele.Call), as.character(myData$Variant), myData$Frequency, myData$Quality, myData$Coverage, myData$Strand.Bias
  )

  Calls.vars = data.frame(Calls.vars)
  NoCalls.vars = data.frame(NoCalls.vars)
  AllCalls.vars = data.frame(AllCalls.vars)

  colnames(Calls.vars) = c(
    "Chrom", "Position", "Ref", "Allele.Call", "Variant", "Frequency", "Quality", "Coverage", "Strand.Bias"
  )

  Strand = ggplot(Calls.vars, aes(Strand.Bias,Chrom, color = Position)) +
    geom_point(aes(size = 5)) + theme_bw() + theme(legend.position = "None") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) + facet_wrap( ~
                                                                             Chrom)
  Qual = ggplot(Calls.vars, aes(Quality, Chrom, color = Position)) + geom_point(aes(size = 5)) +
    theme_bw() + theme(legend.position = "None") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    facet_wrap( ~ Chrom)
  Freq = ggplot(Calls, aes(Frequency,Chrom, color = Position)) + geom_point(aes(size = 5)) +
    theme_bw() + theme(legend.position = "None") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    facet_wrap( ~ Chrom)

  png(
    "composite.png", width = 6.75, height = 12, units = "in", res = 300
  )
  grid.draw(rbind(
    ggplotGrob(Strand), ggplotGrob(Freq),ggplotGrob(Qual), size = "last"
  ))
  dev.off()

}



button.widget = tkbutton(tt, text = "Load", command = getfile, background = "lightgray")
tkgrid(
  tklabel (tt, text = "Load Sequencer Output File \n (excel format)"), button.widget, pady = 20, padx = 10
)

check = tkbutton(tt, text = "Plot Quality Control", command = dosomething, background = "lightgray")
tkgrid(check, pady = 5, padx = 10)



# # alternative function #2.... subset annotation by user-defined QC metrics
# 
# as.TclList <- function(object,...)
#   UseMethod("as.TclList")
# as.TclList.list <- function(stringList)
# {
#   result <- "{"
#   for (i in (1:length(stringList)))
#     result <- paste(result,"{",stringList[[i]],"} ",sep = "")
#   result <- paste(result,"}",sep = "")
#   result
# }
# 
# tkgrid(
#   tklabel(tt,text = "Generate output subset by QC metric", background = "light blue"), pady = 15, padx = 10
# )
# fruits <- list("Q1","Q2","Q3","Q4")
# fruitsTclList <- as.TclList(fruits)
# 
# comboBox <- .Tk.subwin(tt)
# .Tcl(paste(
#   "ComboBox",.Tk.ID(comboBox),"-editable false -values",fruitsTclList
# ))
# tkgrid(tklabel (tt, text = "Coverage", background = "light blue"), comboBox)
# 
# OnOK <- function()
# {
#   fruitChoice <-
#     fruits[[as.numeric(tclvalue(tkcmd(comboBox,"getvalue"))) + 1]]
#   tkdestroy(tt)
#   msg <-
#     paste("Good choice! ",fruitChoice,"s are delicious!",sep = "")
#   tkmessageBox(title = "Fruit Choice",message = msg)
# 
# }
# 
# fruits <- list("Q1","Q2","Q3","Q4")
# fruitsTclList <- as.TclList(fruits)
# 
# # Note that the following doesn't work, because the braces in the fruitsTclList,
# # are interpreted literally as braces to appear in the combo box, rather than
# # as a Tcl list structure.
# # comboBox <- tkwidget(tt,"ComboBox",editable="false",values=fruitsTclList)
# 
# # This does work!
# comboBox <- .Tk.subwin(tt)
# .Tcl(paste(
#   "ComboBox",.Tk.ID(comboBox),"-editable false -values",fruitsTclList
# ))
# tkgrid(tklabel (tt, text = "Frequency", background = "light blue"), comboBox)
# 
# OnOK <- function()
# {
#   fruitChoice <-
#     fruits[[as.numeric(tclvalue(tkcmd(comboBox,"getvalue"))) + 1]]
#   tkdestroy(tt)
#   msg <-
#     paste("Good choice! ",fruitChoice,"s are delicious!",sep = "")
#   tkmessageBox(title = "Fruit Choice",message = msg)
# 
# }
# 
# fruits <- list("Q1","Q2","Q3","Q4")
# fruitsTclList <- as.TclList(fruits)
# comboBox <- .Tk.subwin(tt)
# .Tcl(paste(
#   "ComboBox",.Tk.ID(comboBox),"-editable false -values",fruitsTclList
# ))
# tkgrid(tklabel (tt, text = "Strand.Bias", background = "light blue"), comboBox)
# 
# OnOK <- function()
# {
#   fruitChoice <-
#     fruits[[as.numeric(tclvalue(tkcmd(comboBox,"getvalue"))) + 1]]
#   tkdestroy(tt)
#   msg <-
#     paste("Good choice! ",fruitChoice,"s are delicious!",sep = "")
#   tkmessageBox(title = "Fruit Choice",message = msg)
# 
# }
# 
# 
# 
# 
# 
# OK.but <- tkbutton(tt,text = "OK",command = OnOK, background = "light gray")
# tkgrid(OK.but, pady = 15, padx = 10)
# tkfocus(tt)



#submit to all four datasets
submit <- function() {
  source('C:/Users/vwillia2/Downloads/annotate.C.bio.R')
  source('C:/Users/vwillia2/Downloads/runall3a.R')
  source('C:/Users/vwillia2/Downloads/save.xlsx.R')
  tkmessageBox(message = "Checking variants against Cosmic, ClinVar, TCGA,C.Bioportal,and  Protein databases")
  runall3a(myData)
}
#reset button
reset <- function() {
  tclvalue(myData) <- ""
}

submit.but <-
  tkbutton(tt, text = "Submit", command = submit, background = "lightgray")
reset.but <-
  tkbutton(tt, text = "Reset", command = reset, background = "lightgray")




#tkgrid(tklabel(tt,text = "Generate Annotation"), pady = 10, padx = 10)
tkgrid(
  tklabel(tt, text = "Generate Individual Annotations", background = "light blue"), submit.but,reset.but, pady = 5, padx = 10
)




# Function 3
#check consistency
consis = function() {
  setwd(wd)
  source('C:/Users/vwillia2/Downloads/checkconsis.R')
  checkconsis()
  tkmessageBox(message = "Checking individual variant consistency")
  #tkconfigure(table1,selectmode="extended",rowseparator="\"\n\"",colseparator="\"\t\"")
}
consis = tkbutton(tt, text = "Run", command = consis, background = "light gray")

tkgrid(tklabel (tt, text = "Check Overall Variant Annotation Consistency", background = "light blue"),consis, pady = 5, padx = 10)

#Function 4
# check gene, disease and variants against PUBMED
setwd("C:/Users/vwillia2/Downloads")
source("C:/Users/vwillia2/Downloads/search.PubMed.R")
library(rentrez)
library(XML)
search.PubMed {
  xvar.1 <- tclVar("")
  yvar.1 <- tclVar("")
  x.entry <- tkentry(tt, textvariable = xvar.1)
  y.entry <- tkentry(tt, textvariable = yvar.1)
  reset <- function() {
    tclvalue(xvar.1) <- ""
    tclvalue(yvar.1) <- ""
  }
  reset.but <- tkbutton(tt, text = "Reset", command = reset)
  submit <- function() {
    x <- (tclvalue(xvar.1))
    y <- (tclvalue(yvar.1))
    tkmessageBox(message = "searching Pubmed")
    search.PubMed(x,y)
  }
  submit.but <- tkbutton(tt, text = "submit", command = submit)
  quit.but <-
    tkbutton(
      tt, text = "Close Session",command = function() {
        q(save = "no")
        tkdestroy(tt)
      }
    )
  tkgrid(
    tklabel(tt,text = "Search Gene, Disease, and Variant against PubMed", font = "Bold", background = "light blue"),columnspan = 10, pady = 10
  )
  tkgrid(tklabel(tt,text = "Gene"), x.entry, pady = 5, padx = 10)
  tkgrid(tklabel(tt,text = "Variant"), y.entry, pady = 5, padx = 10)
  tkgrid(submit.but, reset.but, quit.but, pady = 5, padx = 10)
}

search.PubMed()


#Function 5
# check gene and disease against current clinical trials.gov
setwd("C:/Users/vwillia2/Downloads")
library(rclinicaltrials)
library(ggplot2)
library(gdata)
library(plyr)
source('C:/Users/vwillia2/Downloads/save.xlsx.R')
source('C:/Users/vwillia2/Downloads/collect.ClinicalTrials.R')
mydialog <- function() {
  xvar <- tclVar("")
  yvar <- tclVar("")
  x.entry <- tkentry(tt, textvariable = xvar)
  y.entry <- tkentry(tt, textvariable = yvar)
  reset <- function() {
    tclvalue(xvar) <- ""
    tclvalue(yvar) <- ""
  }
  reset.but <-
    tkbutton(tt, text = "Reset", background = "LightGray", command = reset)
  submit <- function() {
    x <- (tclvalue(xvar))
    y <- (tclvalue(yvar))
    tkmessageBox(message = "searching ClinicalTrials.gov")
    collect.ClinicalTrials(x,y)
  }
  submit.but <-
    tkbutton(tt, text = "submit", command = submit, background = "LightGray")
  quit.but <- tkbutton(
    tt, text = "Close Session",background = "LightGray",
    command = function() {
      q(save = "no")
      tkdestroy(tt)
    }
  )
  tkgrid(
    tklabel(tt,text = " Search Disease and Genes against Clinical trials.gov", font = "Bold", background = "light blue"),columnspan = 3, pady = 10)
  tkgrid(tklabel(tt,text = "Disease"), x.entry, pady = 10, padx = 10)
  tkgrid(tklabel(tt,text = "Gene 1"), y.entry, pady = 10, padx = 10)
  tkgrid(submit.but, reset.but, quit.but, pady = 10, padx = 10)
}

mydialog()


