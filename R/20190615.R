A = array(c(3:10),c(2,2,2))
A
A[,1,1]
A[A[,2,2]>9,1,1]
4*c(3,6)
help("attributes")
attributes(A)
a1=c(1:4)
a2=cbind(a1,"5")
mode(a2)
help(sink)
#
# rank
#
help(rank)
rank(x1 <- c(3, 1, 4, 15, 92))
rank(x1 <- c(3, 1, 1, 4, 15, 92), ties.method = "average")
rank(x1 <- c(3, 1, 1, 4, 15, 92), ties.method = "first")
#
# sweep
#
help(sweep)
A = array(1:24, dim=4:2)
A
sweep(A, 1, 5)
A.min = apply(A, 1, min)
A.min
sweep(A, 1, A.min)
m1=matrix(1:4, c(2,2))
m2=matrix(5:8, c(2,2))
m1 %*% m2
m1 %/% m2
m1 * m2
m1 / m2
help("%/%")

## 데이터 프레임 생성
cust_id <- c("c01","c02","c03","c04")
last_name <- c("Kim", "Lee", "Choi", "Park")
cust_mart_1 <- data.frame(cust_id, last_name)
cust_mart_2 <- data.frame(cust_id = c("c05", "c06", "c07"), 
                          last_name = c("Bae", "Kim", "Lim"))

## (1) 행 결합 (위 + 아래)  rbind(A, B)
cust_mart_12 <- rbind(cust_mart_1, cust_mart_2)
cust_mart_7 <- data.frame(cust_id = c("c03", "c04", "c05", "c06", "c07", "c08", "c09"), 
                          buy_cnt = c(3, 1, 0, 7, 3, 4, 1))
cust_mart_12
cust_mart_7
merge(cust_mart_12, cust_mart_7)
# inner join
merge(x = cust_mart_12, y = cust_mart_7, key="cust_id")
# outer join
merge(x = cust_mart_12, y = cust_mart_7, key="cust_id", all=T)
# left outer join
merge(x = cust_mart_12, y = cust_mart_7, key="cust_id", all.x=T)
# right outer join
merge(x = cust_mart_12, y = cust_mart_7, key="cust_id", all.y=T)

# Q 16
char1 = c("A", "A", "B", "C", "C")
num1 = c(1,1,2,2,3)
test1 = cbind(char1, num1)
char2 = c("A", "B", "B", "C", "C")
num2 = c(1,2,3,3,3)
test2 = cbind(char2, num2)
test1d = as.data.frame(test1)
test2d = as.data.frame(test2)
names(test2d) = c("char1", "num1")
merge(x=test1d, y=test2d)
