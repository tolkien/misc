# change working directory to R.2019.2/
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2020.1'))
}

#library(devtools)
#install_github("kingaa/pomp")
#install.packages("psych")
fem = read.csv("./mva/grntFem.csv", header=T)
head(fem)
summary(fem)

library(psych)
uls = fa(fem, 2, rotate="none", fm="minres")
names(uls)
uls$values
plot(uls$values, type="b", pch=19)
uls
uls$scores
biplot(uls, cex=0.7)
