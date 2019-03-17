
Dataset <- read.table("/Users/tolkien/work/misc/R/example6-9.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)
with(Dataset, (t.test(salary, alternative='greater', mu=160, conf.level=.95)))

