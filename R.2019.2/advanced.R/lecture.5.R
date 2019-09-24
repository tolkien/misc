# ex 3.1, H0 : mu = 70, H1 : mu > 70
x <- c(63, 72, 73, 70, 77, 72, 74, 73, 69, 79)
a = 0.05
mx = mean(x)
sx = sd(x)
lbd = mx - qt(a/2, 9, lower.tail = T) * sx/sqrt(10)
ubd = mx + qt(a/2, 9, lower.tail = T) * sx/sqrt(10)
t0 = (mx-70)/(sx/sqrt(10))
1-pt(t0, 9)
# accept H0

# ex 3.2, H0 : mu1 - mu2 = 0, H1 : mu1 - mu2 != 0, s1 == s2 == s
x = c(21.6, 20.8, 17.6, 20.1, 20.1, 21.9, 20.6, 19.4, 21.5, 26.1)
y = c(20.6, 20.4, 20.2, 20.2, 18.0, 19.8, 20.9, 19.7, 20.3, 19.7, 22.7)
a = 0.05
mx = mean(x);sdx = sd(x)
my = mean(y);sdy = sd(y)
sp = sqrt((((10-1)*sdx^2) + (11-1)*sdy^2)/(10+11-2))
t0 = (mx-my)/(sp*sqrt(1/10+1/11))
1-pt(t0, (10+11-2))
lbd = (mx-my) - qt(a/2, 19, lower.tail = F)*sp*sqrt(1/10+1/11)
ubd = (mx-my) + qt(a/2, 19, lower.tail = F)*sp*sqrt(1/10+1/11)
# accept H0

# ex 3.3, H0 : mu1 - mu2 = 0, H1 : mu1 - mu2 != 0, s1 != s2
t0_1 = (mx - my)/sqrt(sdx^2/10 + sdy^2/11)
sw.df = (sdx^2/10 + sdy^2/11)^2/((sdx^2/10)^2/(10-1) + (sdy^2/11)^2/(11-1))
1-pt(t0_1, sw.df)
lbd_1 = (mx-my) - qt(a/2, sw.df, lower.tail = F) * sqrt(sdx^2/10 + sdy^2/11)
ubd_1 = (mx-my) + qt(a/2, sw.df, lower.tail = F) * sqrt(sdx^2/10 + sdy^2/11)
# accept H0

# ex 3.5, paired t-test
x = c(106, 107, 105, 113, 107, 112, 109, 112, 111, 114)
y = c(100, 92, 91, 82, 87, 96, 101, 96, 79, 96)
a = 0.05
dd = x - y
nn = length(dd)
md = mean(dd);sdd=sd(dd)
t0 = md/(sdd/sqrt(nn))
1-pt(t0, nn-1)
lbd = md - qt(a/2, nn-1, lower.tail = F)*sdd/sqrt(nn)
ubd = md + qt(a/2, nn-1, lower.tail = F)*sdd/sqrt(nn)
# reject H0