require(tcltk)
setwd("C:/Users/vwillia2/Downloads")
library(rclinicaltrials)
library(ggplot2)
library(gdata)
library(plyr)
source('C:/Users/vwillia2/Downloads/save.xlsx.R')
source('C:/Users/vwillia2/Downloads/collect.ClinicalTrials.R')
mydialog <- function(){
xvar <- tclVar("")
yvar <- tclVar("")
tt <- tktoplevel()
tkwm.title(tt,"Search Online annotation")
x.entry <- tkentry(tt, textvariable=xvar)
y.entry <- tkentry(tt, textvariable=yvar)
reset <- function() {
tclvalue(xvar)<-""         
tclvalue(yvar)<-""         
}
reset.but <- tkbutton(tt, text="Reset", command=reset)
submit <- function() {
x <- (tclvalue(xvar))
y <- (tclvalue(yvar))
tkmessageBox(message="searching ClinicalTrials.gov")
collect.ClinicalTrials(x,y)
}
submit.but <- tkbutton(tt, text="submit", command=submit)
quit.but <- tkbutton(tt, text = "Close Session", 
command = function() {
q(save = "no")
tkdestroy(tt)
}        
)
tkgrid(tklabel(tt,text="Enter Disease and Genes for ClinicalTrials.gov"),columnspan=3, pady = 10)
tkgrid(tklabel(tt,text="Disease"), x.entry, pady= 10, padx= 10)
tkgrid(tklabel(tt,text="Gene 1"), y.entry, pady= 10, padx= 10)
tkgrid(submit.but, reset.but, quit.but, pady= 10, padx= 10)

}



mydialog(
  
  )
