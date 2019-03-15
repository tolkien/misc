# https://colab.research.google.com/notebooks/welcome.ipynb
# function
u=1
v=8
f=function(x){
   x = x + 1
   u = u + x
   return(u)
}
f(v)

# method 1.
d.mean=function(data) {
  sum(data)/length(data)
}
x=rnorm(100, mean=4, sd=1)
d.mean(x)

# method 2. fix() -> there is an edit popup to write fn
#      you may use edit()
fix(d.var)
#function(data) {
#  data.var = sum((data - d.mean(data))^2) / length(data) - 1
#  return (data.var)
#}

# method 3. load external fn via source()
source("./rangefunction.txt")
d.range(x)

# function as parameter
f1=function(x, y) { return(x+y) }
f2=function(x, y) { return(x-y) }
g=function(h,x,y) { h(x,y) }
g(f1,3,2)
g(f2,3,2)

# set parameter's default value
f_default=function(data, num=1) {
  d.min=min(data)
  d.max=max(data)
  switch(num, mean(data), var(data), c(d.min, d.max))
}
f_default(x)
f_default(x, 2)
f_default(num=3, data=x)

# functions for function
is.function(f1)
is.function(x)
args(f_default)
attributes(f_default)

# operater as function
"%a2b%"=function(a,b) { return(a + 2*b) }
3 %a2b% 5
