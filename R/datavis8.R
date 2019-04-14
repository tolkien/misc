# chapter 8
# required packages: sp, maps, maptools, dismo, rgdal, ggplot2
# http://www.gadm.org (Global Administrative Area)
library(sp)

# 전체지도
gadm1=readRDS("datavis/KOR_adm0.rds")
plot(gadm1)

# 시도별 행정지도
gadm2=readRDS("datavis/KOR_adm1.rds")
plot(gadm2)

# 시군구별 행정지도
gadm3=readRDS("datavis/KOR_adm2.rds")
plot(gadm3)
plot(gadm3[gadm3$NAME_1=="Seoul",], col="green")

# 세계지도 그리기
#install.packages("maps")
library(maps)
map()
map(database="world", region="South Korea")
eastasia=c("South Korea", "North Korea", "China", "Japan")
map(database="world", region=eastasia)

# ggplot2를 이용한 동북아시아 지도 그리기
library(ggplot2)
wrld=map_data("world")
eastasia_1=wrld[wrld$region %in% eastasia,]
qplot(long, lat, data=eastasia_1, geom="polygon", fill=region, group=group)

# google map을 이용한 우리나라 지도
#mymap=gmap("South Korea", type="roadmap")
# -> REQUEST_DENIED:South+Korea
# https://console.cloud.google.com/ 에 login
# API and Service -> Library -> Maps Static API -> ...
# run following: register_google("<your API key>")

# draw pollution map using sp library
library(sp)
par(family = "AppleGothic")
gadm4=readRDS("datavis/KOR_adm1.rds")
plot(gadm4, col="grey")
pollution = read.table("datavis/pollution.txt", header=T)
pollution$width=2/5
pollution$height=0.1
pollution$space=0.1
spaceDif=0.05
for(i in 1:dim(pollution)[1]) {
  coords = SpatialPoints(data.frame(
    cbind(pollution$경도[i], pollution$위도[i]))
    , proj4string = CRS("+proj=longlat"))
  plot(coords, col="red3", pch=20, cex=1.5, add=T)
}

for(i in 1:dim(pollution)[1]) {
  a = c(pollution$경도[i] - pollution$width[i],
        pollution$경도[i] + pollution$width[i],
        pollution$경도[i] + pollution$width[i],
        pollution$경도[i] - pollution$width[i])
  b = c(pollution$위도[i] + pollution$space[i] - pollution$height[i] + spaceDif,
        pollution$위도[i] + pollution$space[i] - pollution$height[i] + spaceDif,
        pollution$위도[i] + pollution$space[i] + pollution$height[i] + spaceDif,
        pollution$위도[i] + pollution$space[i] + pollution$height[i] + spaceDif)
  
  polygon(x=a, y=b, col="white")
}

library(stringr)
cityLabels=str_c(pollution$시도, pollution$오존농도)
cityCoord=matrix(c(t(pollution$경도)
                   , t(pollution$위도 + pollution$space + spaceDif))
                 , dim(pollution)[1])
text(cityCoord, labels = cityLabels, cex=0.6, bg="white")
text(128, 38.6, labels = "도시별 오존농도", cex=2)
