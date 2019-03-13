# input via keyboard
v1=c(51, 56, 80, 78, 99)
v1
v2=scan()
v2
v3=scan(what="") # or what="character"
dat1=data.frame()
dat1=edit(dat1)
dat1

# load data from external file
setwd("/home/yjoh/work/R/src")
data2_1 = read.table(file="example2-1.txt")
data2_1
data2_2 = read.table(file="example2-2.txt", header=TRUE)
data2_2
data2_3 = read.table(file="example2-3.txt", header=TRUE,
                     na.strings=c("miss", "NA"))
data2_3
data2_4 = read.table(file="example2-4.txt", header=TRUE,
                     sep=",")
data2_4
data2_5 = read.csv(file="example2-4.txt")
data2_5
data2_6 = scan(file="example2-3.txt",
               what=list(Current=0, Innov=0, Loc=""),
               skip=1, sep="",
               na.strings=c("miss", "NA"))
data2_6 #data2_6 is not data.frame, but list
data2_7 = as.data.frame(data2_6)
data2_7 #convert list to data.frame
library(openxlsx)
data2_8 = read.xlsx("example2-2.xlsx", sheet=1)
data2_8
library(XLConnect)
data2_9 = readWorksheetFromFile("example2-2.xlsx", sheet=1)
data2_9
website="http://www.statsci.org/data/general/auction.txt"
data2_11 = read.table(website, header=TRUE)
data2_11

# data out
# sink()
sink("lecture3.out.txt")
v1=c(51, 56, 80, 78, 99, NA)
mean(v1, na.rm=TRUE)
sink()

# source() with sink()
sink("lecture3.out2.txt")
source("example1.R", echo=TRUE)
sink()

# cat(file=..., append=...)
v1=c(1,3,5,7,9)
v2=c(2,4,6,8,10)
v3=v1 * v2
v4=v1 + v2

cat("Vector v1=(", v1, ")", "\n", file="lecture3.out3.txt")
cat("Vector v2=(", v2, ")", "\n", file="lecture3.out3.txt", append=TRUE)
cat("Vector v1*v2=(", v3, ")", "\n", file="lecture3.out3.txt", append=TRUE)
cat("Vector v1+v2=(", v4, ")", "\n", file="lecture3.out3.txt", append=TRUE)

# write.table() with builtin data "iris"
write.table(iris, file="iris1.txt")
write.table(iris, file="iris2.txt", row.names=FALSE)
write.table(iris, file="iris3.txt", row.names=FALSE, quote=FALSE)
write.table(iris, file="iris4.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(iris, file="iris5.txt", row.names=FALSE, quote=FALSE, sep=",")

# write.xlsx()
write.xlsx(iris, "iris6.xlsx")
# use XLConnect package
writeWorksheetToFile("iris7.xlsx", iris, sheet="FirstSheet")
