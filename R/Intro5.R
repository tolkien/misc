Dataset <- read.table("salary.csv", header=TRUE, 
                      sep=",", na.strings="NA", dec=".",
                      strip.white=TRUE)
with(Dataset, (t.test(임금, alternative='two.sided', mu=0.0,
                        conf.level=.95)))
Dataset <- within(Dataset, {
  성별 <- factor(성별, labels=c('male','female'))
})

numSummary(Dataset[,"임금", drop=FALSE], groups=Dataset$성별, 
           statistics=c("mean", "sd", "IQR", "quantiles"),
           quantiles=c(0,.25,.5,.75,1))

t.test(Dataset$임금[Dataset$성별=="male"])
t.test(Dataset$임금[Dataset$성별=="male"])$conf.int
t.test(Dataset$임금[Dataset$성별=="female"])$conf.int
t.test(Dataset$임금)$conf.int
t.test(Dataset$임금, conf.level = 0.99)$conf.int
