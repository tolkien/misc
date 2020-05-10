# change working directory to R.2019.2/
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2020.1'))
}

# 4.5
beer.data = read.table("./mva/beerbrand.csv", header = T, sep = ",")
head(beer.data)
summary(beer.data)
hc = hclust(dist(beer.data), method="single")
hc
plot(hc, hang=-1)

#install.packages("pls")
library(pls)
zbeer.data = stdize(as.matrix(beer.data))
zhc = hclust(dist(zbeer.data), method="centroid")
plot(zhc, hang=-1)
zhc.cent24 = cutree(zhc, 2:4)
zhc.cent24

kmc = kmeans(zbeer.data, 2)
kmc
plot(zbeer.data, col=kmc$cluster, pch=16)
pairs(zbeer.data, col=kmc$cluster, pch=16)

# 4.6
head(USArrests)
summary(USArrests)
hc1 = hclust(dist(USArrests), method="average")
plot(hc1, hang=-1)
hcmember = cutree(hc1, k=4)
hcmember
cent = NULL
for(k in 1:4) {
  cent = rbind(cent, colMeans(USArrests[hcmember==k, , drop=F]))
}
cent

zUSArrests = stdize(as.matrix(USArrests))
kmc1 = kmeans(zUSArrests, 4)
kmc1
pairs(zUSArrests, col=kmc1$cluster, pch=16)
