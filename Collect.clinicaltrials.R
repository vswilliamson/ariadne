
# clinical trials
#install.packages("devtools")
#library(devtools)
#install_github("sachsmc/rclinicaltrials")
# readinteger <- function()
# { 
#   n <- readline(prompt="Enter an integer: ")
#   return(as.integer(n))
# }
# 
# print(readinteger())
collect.ClinicalTrials = function (x, y){
search = paste(x," + ",y, sep = "")
counts = clinicaltrials_count(query = search)
if(counts > 0){
studies <- clinicaltrials_download(query = search, include_results = TRUE)
study.info =data.frame(studies$study_information[1])
png (filename = "C:/Users/vwillia2/Downloads/test.plot.png")
phase = count(study.info[,15])
barplot(phase[,2], ylab = "Number of Studies")
dev.off()
locations = data.frame(studies$study_information[2])
arms = data.frame(studies$study_information[3])
interventions = data.frame(studies$study_information[4])
outcomes = data.frame(studies$study_information[5])
textblocks = data.frame(studies$study_information[6])
filename = paste(x,"+",y, "_Clinicalinfo.xls", sep = "")
save.xlsx(filename, study.info, locations, arms, interventions, outcomes)
}

}



