#library(tidyverse)
#library(showtext)  # 글꼴, install.packages("showtext")
#library(extrafont) # install.packages("extrafont")
#font_import(prompt = F, pattern = "D2")
#loadfonts(quiet = F)
par(family = "AppleGothic")

# report 1
kings = read.table("datavis/chosun\ kings.txt", header=T)
P <- cumsum(kings$Life)
plot(1:27, P, type="n", xlab="Order", ylab="Accumlated Life",
     main="Chosun Dynasty")
polygon(c(0,0,1,1), c(0,P[1],P[1],0))
for(i in 2:27) {
  polygon(c(i-1,i-1,i,i), c(P[i-1], P[i], P[i], P[i-1]),
          col=rainbow(27)[i])
}
segments(0, 0, 27, 1243, lty="dotted", lwd=2, col="darkgreen")

# report 2
# https://www.knou.ac.kr/knou/pbre/EHPSchlSong.jsp
#install.packages(c("tm","wordcloud"))
#install.packages("rJava")
#install.packages("KoNLP")
library(tm)
library(wordcloud)
library(rJava)
library(KoNLP)
par(family="Gulim")
ktext = Corpus(DirSource("datavis/gyoga/",
                         encoding="UTF-8", recursive = T))
words1 = unlist(sapply(ktext[[1]]$content, extractNoun, USE.NAMES = F))
words1freq = table(words1)
words1freq <- words1freq[!(names(words1freq)
                           %in% c("곳", "교", "리", "속", "앞",
                                  "한"))]
sort(words1freq, decreasing=T)[1:12]
wordcloud(names(words1freq), freq=words1freq, max.words=50)

# report 3
data(Titanic)
mosaicplot(~ Class+Survived, data=Titanic, color=c("grey", "red"))

# report 4
#install.packages("sp")
library(sp)
#gadm = readRDS("datavis/gadm36_KOR_0_sp.rds")
gadm0 = readRDS("datavis/KOR_adm0.rds")
plot(gadm0)
gadm2 = readRDS("datavis/KOR_adm2.rds")
seoul = gadm2[gadm2$NAME_1=="Seoul",]
plot(seoul)
gadm1 = readRDS("datavis/KOR_adm1.rds")
seoul = gadm1[gadm1$NAME_1 == "Seoul",]
plot(seoul, col="green")

library(sp)
gadm1 = readRDS("datavis/KOR_adm1.rds")
plot(gadm1, col="grey")
pollution = read.table("datavis/pollution.txt", header=T)
pollution$width = 2/5
pollution$height = 0.1
pollution$space = 0.1
spaceDif = 0.05
# draw a point on city
for (i in 1:dim(pollution)[1]) {
  coords = SpatialPoints(data.frame(
    cbind(pollution$경도[i], pollution$위도[i]))
    , proj4string = CRS("+proj=longlat"))
  plot(coords, col = "red3", pch = 20, cex = 1.5, add = T)
}

# draw a rectangle for text
for (i in 1:dim(pollution)[1]) {
  a <- c(pollution$경도[i] - pollution$width[i],
         pollution$경도[i] + pollution$width[i],
         pollution$경도[i] + pollution$width[i],
         pollution$경도[i] - pollution$width[i])
  b <- c(pollution$위도[i] + pollution$space[i]
         - pollution$height[i] + spaceDif,
         pollution$위도[i] + pollution$space[i]
         - pollution$height[i] + spaceDif,
         pollution$위도[i] + pollution$space[i]
         + pollution$height[i] + spaceDif,
         pollution$위도[i] + pollution$space[i]
         + pollution$height[i] + spaceDif)
  polygon(x=a, y=b, col="white")
}

library(stringr)
cityLabels <- str_c(pollution$시도, pollution$미세먼지농도)
cityCoord <- matrix(c(t(pollution$경도),
                      t(pollution$위도 + pollution$space
                        + spaceDif)),
                    dim(pollution)[1])
text(cityCoord, labels = cityLabels, cex = 0.6, bg="white")
text(128, 38.6, labels = "도시별 미세먼지농도", cex = 2)
