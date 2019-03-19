# treemap for GNI.2010 which is modifed from data(GNI2010)

library(treemap)

GNI.2010 <- read.table("GNI-2010.txt", header=T)[1:104,]
str(GNI.2010)

windows(height=8, width=7)
treemap(GNI.2010,index=c("sector", "item"),vSize="principal",vColor="yield",
    type="value",bg.labels="yellow",title="Portpolio Evaluation GNI.2010 [1:104]")

GNI.2010$yield.total <- GNI.2010$principal*as.numeric(GNI.2010$yield)
GNI.2010.a <- aggregate(GNI.2010[,3:5],by=list(GNI.2010$sector),sum)
GNI.2010.a$yield.avg <- GNI.2010.a$yield.total/GNI.2010.a$principal

windows(height=8, width=7)
treemap(GNI.2010.a,index=c("Group.1"),vSize="principal",vColor="yield.avg",
    type="value",bg.labels="yellow",title="Portpolio Evaluation GNI.2010 [1:104]")

# end