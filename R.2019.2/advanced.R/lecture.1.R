# working directory
setwd(choose_dir()) # this function is working on MS windows only

# change working directory to R.2019.2/advanced.R
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/advanced.R'))
}

insurance.data=read.table("data/insurance.txt", header=T)
insurance.data[c(10:11),]
insurance2.data=read.table("data/insurance2.txt", header=T,
                           na.string="-9")
insurance2.data[c(15:16),]
csv.data=read.csv("data/csv.txt", header=T)
tab.data=read.table("data/tab.txt", header=T, sep="\t")
#write.table(tab.data, file="data/test.txt")

# fixed width format
fwf.data=read.fwf(file="data/insurance3.txt",
                  widths=c(2,2,3,3,3,6,6),
                  col.names=c("id", "sex", "job", "religion", "edu", "amount", "salary"))
fwf.data[fwf.data$job == -9, "job"] = NA
fwf.data[fwf.data$edu == -9, "edu"] = NA
fwf.data[fwf.data$salary == -9, "salary"] = NA
head(fwf.data, n=3)

fwf2.data=read.fwf(file="data/insurance3.txt",
                  widths=c(2,-2,-3,3,3,6,6),
                  col.names=c("id", "religion", "edu", "amount", "salary"))
head(fwf2.data, n=3)

# excel file
#install.packages("xlsx")
library(xlsx)
alcohol.data = read.xlsx("data/alcohol.xlsx", 1)
head(alcohol.data, n=2)
alc2.data = read.xlsx("data/alcohol.xlsx", 1, colIndex=c(1,2,6:7))
head(alc2.data, n=2)

# read spss data
#install.packages("foreign")
library(foreign)
ex1 = read.spss("data/ex1-1.sav",
                to.data.frame=T, use.value.label=T)
ex1
mouse.data = ex1[rep(1:nrow(ex1), ex1$count),]
head(mouse.data)
mouse.table = table(mouse.data$shock, mouse.data$response)
mouse.table
summary(mouse.table)

# load & save RData
# save(ex1, file="data/ex1.RData")
rm(ex1)
ex1
load(file="data/ex1.RData")
ex1
