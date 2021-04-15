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
# column: var, row: value
class(Cars93)
Cars93 = tbl_df(Cars93)
class(Cars93)
# p64 select rows
slice(Cars93, 1)
slice(Cars93, c(1,4,10,15, n()))
filter(Cars93, Manufacturer == "Audi" & Min.Price > 25)
# p65 sort
Cars93 = arrange(Cars93, Price)
head(arrange(Cars93, desc(MPG.city), Max.Price), 7)
# p66 select col (ends_with, matches, num_range)
head(select(Cars93, Manufacturer, Price), 3)
head(select(Cars93, Manufacturer:Price), 3)
head(select(Cars93, -Min.Price, -Max.Price), 3)
head(select(Cars93, starts_with("Man")), 3)
head(select(Cars93, contains("Price")), 3)
head(select(Cars93, myPrize = Price, Min.Price), 3)
# p68 uniqueness
Cars93_1 = select(Cars93, Manufacturer, EngineSize)
dim(Cars93_1)
Cars93_1 = distinct(Cars93_1)
dim(Cars93_1)
dim(Cars93)
dim (distinct(Cars93, Manufacturer))
dim (distinct(Cars93, Manufacturer, EngineSize))
dim (distinct(Cars93, Manufacturer, rr=round(EngineSize)))
# p69 create variables
m = mutate(Cars93, is_ford = Manufacturer == "Ford")
m[1:3, c(1,28)]
transmute(Cars93, is_ford = Manufacturer == "Ford")
head(transmute(Cars93, Manufacturer, is_ford = Manufacturer == "Ford", num_ford = ifelse(is_ford, -1, 1)), 3)
# p70 grouping
by_type = group_by(Cars93, Type)
summarize(by_type,
    count = n(), min_es = min(EngineSize),
    max_es = max(EngineSize))
Cars93 %>%
    group_by(Type) %>%
    summarize(count = n(), min_es = min(EngineSize), max_es = max(EngineSize))
slice(by_type, 1:2)
Cars93 %>% group_by(Type) %>% slice(1:2)
Cars93 %>% mutate(ES2 = EngineSize^2) %>% 
    group_by(Type) %>%
    summarize(min.ES2 = min(ES2)) %>%
    arrange(desc(min.ES2))
# p73 window function
Cars93 %>%
    group_by(Type) %>%
    arrange(Type) %>%
    select(Manufacturer:Price) %>%
    mutate(cmean=cummean(Price), csum = cumsum(Price))

# p74 data.table
#install.packages("data.table")
require("data.table")
Cars93 = data.table(Cars93)
head(Cars93)
tables()

# p75 data.table: var
Cars93$tmp1 = Cars93[, j = Manufacturer == "Ford"]
Cars93[, tmp2 := rnorm(nrow(Cars93))]
# p75 data.talbe: delete var
Cars93[, tmp1 := NULL]
Cars93$tmp2 = NULL
# p75 data.table: indexing, subset
Cars93[i = 2]
Cars93[i = c(1,5)]
Cars93[i = -c(1:5)]
Cars93[j = 3]
Cars93[j = "Price"]
Cars93[j = Price]
Cars93[i=1:3, j = "Price", with = FALSE]
Cars93[1:3, .(Price, Horsepower, Diff.Price = Max.Price - Min.Price, Mean.Price = mean(Price))]
# p78 data.table: key
setkey(Cars93, Type)
key(Cars93)
# p78 data.table: key & subset
head(Cars93["Van"], 3)
setkey(Cars93, Type, DriveTrain, Origin)
Cars93[.("Van", "4WD", "non-USA")]
#install.packages("microbenchmark")
require(microbenchmark)
N = 1000000
dat = data.table(
    x = sample(LETTERS[1:20], N, replace=TRUE),
    y = sample(letters[1:5], N, replace=TRUE))
head(dat, 3)
setkey(dat, x, y)
microbenchmark(
    data.table = dat[list(c("B", "D"), c("b", "d"))],
    dplyr = dat %>% slice(x %in% c("B", "D") & y %in% c("b", "d")),
    baseR = dat[x %in% c("B", "D") & y %in% c("b", "d")]
)
# p80 data.table: calc by group
Cars93[, .(mean = mean(Price), IQR = IQR(Price), media = median(Price)), by = Type]
