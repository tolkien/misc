# mosaic plot of Titanic data

data(Titanic)
str(Titanic)
addmargins(apply(Titanic,c(1,4),sum))

mosaicplot(~ Class+Survived,data=Titanic,color=c("grey","red"))
x11()
mosaicplot(~ Sex+Survived,data=Titanic,color=c("grey","red"))
x11()
mosaicplot(~ Age+Survived,data=Titanic,color=c("grey","red"))
x11()
mosaicplot(~ Sex+Survived,data=as.table(Titanic["1st",,"Adult",]),off=1,color=c("grey","red"),main="1st+Adult")
x11()
mosaicplot(~ Sex+Survived,data=as.table(Titanic["2nd",,"Adult",]),off=1,color=c("grey","red"),main="2nd+Adult")
x11()
mosaicplot(~ Sex+Survived,data=as.table(Titanic["3rd",,"Adult",]),off=1,color=c("grey","red"),main="3rd+Adult")
x11()
mosaicplot(~ Sex+Survived,data=as.table(Titanic["Crew",,"Adult",]),off=1,color=c("grey","red"),main="Crew+Adult")

x11()
mosaicplot(~ Class+Survived,data=as.table(Titanic[,"Male","Adult",]),color=c("grey","red"),main="Male+Adult")
x11()
mosaicplot(~ Class+Survived,data=as.table(Titanic[,"Female","Adult",]),color=c("grey","red"),main="Female+Adult")

x11()
mosaicplot(~ Class+Sex+Survived,dir=c("v","v","h"),data=Titanic[,,"Adult",],off=c(1,2),color=c("grey","red"),main="Adult")
# end




