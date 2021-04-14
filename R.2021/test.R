#install.packages("jsonlite")
library("jsonlite")

# p43 install packages
if (!require(dplyr)) install.packages("dplyr")
library("dplyr")
if (!require(devtools)) install.packages("devtools")
#library("devtools")
#install_github("hadley/dplyr")

# p48 vector
data(Cars93, package = "MASS")
hp = Cars93[1:10, "Horsepower"]
hp[c(1,6)]
hp[-c(2:5, 7:10)]
hp[hp < 150]

# p49 factor
class(Cars93)
ls(Cars93)
class(Cars93$Cylinders)
summary(Cars93$Cylinders)

# p50 list
model = lm(Price ~ Cylinders + Type + EngineSize + Origin, data = Cars93)
ls(model)
model$coefficients

# p51 dataframe
w = Cars93$Cylinders %in% c("3", "4") & Cars93$Horsepower < 80
str(Cars93[w, ])

# p52 array
#install.packages("vcd")
library("vcd")
data(PreSex)
PreSex[, , 1, 2]
PreSex[, , "Yes", "Men"]

# p54 missing value
sum(is.na(Cars93))
# install.packages("VIM")
require("VIM")
matrixplot(Cars93, sortby = "Weight", cex.axis=0.6)

# p56 class & method
length(methods(summary))
class(Cars93$Cylinders)
summary(Cars93$Cylinders)
summary(as.character(Cars93$Cylinders))

# p58 apply
func <- function(x) {
    return (sum (is.na(x)))
}
na = apply(X = Cars93, MARGIN = 2, FUN = func)
na[ na > 0]

p = ncol(Cars93)
na_for = numeric(p)
for (i in 1:p) {
    na_for[i] = func(Cars93[, i])
}
identical(as.numeric(na), na_for)

# p59 lapply
#install.packages("robCompositions")
library("robCompositions")
m = robCompositions::missPatterns(Cars93)
lapply(m, length)
sapply(m, length)

# p61 aggregate
args(aggregate)
methods(aggregate)
args(aggregate.data.frame)
aggregate(Cars93[, c("Horsepower", "Weight")], by = list(Cars93$Cylinders), median)

# p62 dplyr
