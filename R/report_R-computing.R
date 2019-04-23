#1.
# 1)
set.seed(367707)
# 2)
vec1 = rnorm(10, mean = 0, sd = 1)
vec2 = rnorm(10, mean = 0, sd = 1)
# 3)
vectodat = data.frame(vec1, vec2)

#2.
# 1)
winedat=read.table("wine.data", sep = ",")
str(winedat)
# 2)
num_var = ncol(winedat) # 변수의 개수
num_var
num_obs = nrow(winedat) # 관측치의 개수
num_obs
# 3)
write.table(winedat, "wine.txt", quote = F, sep = "\t")
# 4)
wine_tab = read.table("wine.txt", header = T, sep = "\t")
head(wine_tab)

#3.
# 1)
set.seed(367707)
x <- round(runif(10,0,1)*100)
cnt=0
sum=0
for(i in x) {
  cnt = cnt + 1
  sum = sum + i
}
mean_x = sum / cnt
mean_x
# 2)
print(mean(x))

#4.
# 1)
cnt_ = c(5, 3, 1, 3, 5)
val_ = c(9, 7, 5, 3, 1)
for(i in 1:5) {
  cat("[1]")
  for(j in 1:cnt_[i]) {
    cat(" ", val_[i])
  }
  cat("\n")
}

# 2)
cnt_ = c(5, 3, 1, 3, 5)
val_ = c(9, 7, 5, 3, 1)
i=1
j=1
while(i<=5) {
  cat("[1]")
  while(j<=cnt_[i]) {
    cat(" ", val_[i])
    j = j + 1
  }
  cat("\n")
  i = i + 1
  j = 1
}

# 3)
cnt_ = c(5, 3, 1, 3, 5)
val_ = c(9, 7, 5, 3, 1)
i=1
j=1
repeat {
  if (i>5) break
  cat("[1]")
  repeat {
    if (j>cnt_[i]) break
    cat(" ", val_[i])
    j = j + 1
  }
  cat("\n")
  i = i + 1
  j = 1
}

#5.
comp <- function(x, y) {
  cat("x =", x, "\n")
  cat("y =", y, "\n")
  cmp_ = "="
  if (x < y) {
    cmp_ = "<"
  } else if (x > y) {
    cmp_ = ">"
  }
  cat("x", cmp_, "y\n")
}
comp(2,3)
comp(4,3)
comp(2,2)
