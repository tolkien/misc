# List (length, mode, names)
a=1:10
b=11:15
k1=list(vec1=a,vec2=b,descrip="example")
length(k1)
mode(k1)
names(k1)

k1$vec1
k1[[1]]
k1[[2]]
k1[[4]] <- list(c(T,F))
k1[[2]][9] = 9
k1[[3]] <- NULL        # remove 3rd field
k1[[2]] <- k1[[2]][-9] # delete 9th element of 2nd field

# dataframe (read.table, data.frame, as.data.frame)
d2=read.table("./story.txt", row.names='num', header=T)
char1=rep(LETTERS[1:3],c(2,2,1))
num1 = rep(1:3,c(2,2,1))
d3=data.frame(char1, num1)
a1=c("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o")
dim(a1) <- c(5,3)
d4=as.data.frame(a1)

cbind(d2,d3)
char1=rep(LETTERS[1:3],c(1,2,2))
num1=rep(1:3,c(1,1,3))
d1=data.frame(char1, num1)
rbind(d1,d3) # should be same col name and number
merge(d1,d3) # should be same data structure
