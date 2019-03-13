# matrix (length, mode, dim, dimnames)
m1 = matrix(1:9, nrow=3)
dimnames(m1)=list(paste("row",c(1:3)),paste("col",c(1:3)))
m1
length(m1)
mode(m1)
dim(m1)

cbind(c(1,2),c(3,4))
rbind(c(5,6),c(7,8))
m2=1:12
dim(m2) <- c(3,4)
m2

# edit a matrix
m3=matrix(seq(1,9,1), ncol=3, byrow=T)
m3
m3[1,]
m3[,3]
m3[,3]>4
m3[m3[,3]>4, 2]
m3[2,3]

# apply()
Height=c(140,155,142,175)
size.1=matrix(c(130,26,110,24,118,25,112,25), ncol=2, byrow=T,
              dimnames=list(c("Lee","Kim","Park","Choi"),
                            c("Weight", "Waist")))
size=cbind(size.1, Height)
size
colmean=apply(size, 2, mean) # 2: get average of columns
colmean
rowmean=apply(size, 1, mean) # 1: get average of rows
rowmean
colvar=apply(size, 2, var)  # 2: get variance of columns
colvar

# sweep() # default operation is subtraction
sweep(size, 2, colmean) # 2: get col diff from colmean
sweep(size, 1, rowmean) # 1: get row diff from rowmean
sweep(size, 1, c(1,2,3,4), "+") # 1: get row sum from colmean

# matrix math operation
m01=matrix(1:4, nrow=2)
m02=matrix(5:8, nrow=2)
m01 %*% m02 # matrix multiple
m01 %*% solve(m01)  # inverse matrix
t(m01)      # transpose

# array (length, mode, dim, dimnames)
a1 = array(1:24, c(3,3,2))
dimnames(a1) <- list(paste("row", c(1:3)),
                     paste("col", c(1:3)),
                     paste("ar", c(1:2)))
a1
length(a1)
mode(a1)
dim(a1)
a2=1:24
dim(a2) <- c(3,4,2)
a2
array(1:6)         # 1-dim array, not list
array(1:6, c(2,3)) # 2-dim array, not matrix
array(1:16, c(2,2,2,2))

a3=array(1:8, dim=c(2,2,2))
a4=array(8:1, dim=c(2,2,2))
a3 + a4
a3 * a4
a3 %*% a4    # same as sum(a3 * a4), but it's array
sum(a3 * a4) # scala value
a3[1,1,]
a3[1,,-2]
