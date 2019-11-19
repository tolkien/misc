WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/probabilities'))
}

ld = c(4, 4, 4, 3, 3, 2, 2, 3, 2, 2, 4, 3)
sc = c(1, 2, 1, 1, 1, 3, 3, 4, 3, 3, 3, 2)
pf = c(2, 3, 3, 2, 2, 1, 1, 2, 1, 1, 1, 4)
pc = c(3, 1, 2, 4, 4, 4, 4, 1, 4, 4, 2, 1)

# Q4
gm = dbinom(x=0:10, size=10, prob = 0.04)
sum(gm)
plot(gm, type='h', xlab="success", ylab="prob.")

ngm = dnbinom(x=0:190, size=10, prob = 0.1)
plot(ngm, type='h', xlab="trials", ylab="prob.", xlim=c(10,190), xaxt='n')
axis(1, at = seq(10,190,by=10), las=2)

par(mfrow=c(1,1))
# 5 star, 0.04
ngm = dnbinom(x=0:190, size=5, prob = 0.04)
plot(ngm, type='l', col="red",
     xlab="trials", ylab="prob.", xlim=c(10,190), ylim=c(0,0.015), xaxt='n', yaxt='n')
axis(1, at = seq(0,190,by=10), las=2)
axis(2, at = seq(0.000,0.015,by=0.005), las=2)

par(new=T)
ngm2 = dnbinom(x=0:190, size=4, prob = 0.04)
plot(ngm2, type='l', col="blue",
     xlab="", ylab="", xlim=c(10,190), ylim=c(0,0.015), xaxt='n', yaxt='n')

par(new=T)
ngm3 = dnbinom(x=0:190, size=3, prob = 0.04)
plot(ngm3, type='l', col="green",
     xlab="", ylab="", xlim=c(10,190), ylim=c(0,0.015), xaxt='n', yaxt='n')

par(new=T)
ngm3 = dnbinom(x=0:190, size=2, prob = 0.04)
plot(ngm3, type='l', col="black",
     xlab="", ylab="", xlim=c(0,190), ylim=c(0,0.015), xaxt='n', yaxt='n')

p0 = pnbinom(1:300, size=5, prob = 0.04)
plot(p0, col="red", type='l', xlim=c(0,300), ylim=c(0,0.9))
par(new=T)
p1 = pnbinom(1:300, size=4, prob = 0.04)
plot(p1, col="green", type='l', xlab="", ylab="", xlim=c(0,300), ylim=c(0,0.9))
par(new=T)
p2 = pnbinom(1:300, size=3, prob = 0.04)
plot(p2, col="blue", type='l', xlab="", ylab="", xlim=c(0,300), ylim=c(0,0.9))
par(new=T)
p3 = pnbinom(1:300, size=2, prob = 0.04)
plot(p3, col="black", type='l', xlab="", ylab="", xlim=c(0,300), ylim=c(0,0.9))
par(new=T)
p3 = pnbinom(1:300, size=1, prob = 0.04*(2/85))
plot(p3, col="cyan", type='l', xlab="", ylab="", xlim=c(0,300), ylim=c(0,0.9))
pnbinom(99, size=1, prob = 0.04/85)
pnbinom(199, size=1, prob = 0.04/85)
pnbinom(299, size=1, prob = 0.04/85)
pnbinom(29, size=1, prob = 0.04)
pnbinom(14, size=1, prob = 0.04*(2/85))
pnbinom(98, size=1, prob = 0.04*(2/85))
pnbinom(98, size=1, prob = 0.04*(6/85))

# Q2
par(mfrow=c(2,2))
dice12 = sample(1:6, 12, replace = TRUE)
hist(dice12, prob=T, breaks=c(0:6), ylim = c(0, 0.3), main = "(a) n=12")
abline(b=0, a=1/6, col=2)
dice120 = sample(1:6, 120, replace = TRUE)
hist(dice120, prob=T, breaks=c(0:6), ylim = c(0, 0.3), main = "(b) n=120")
abline(b=0, a=1/6, col=2)
dice1200 = sample(1:6, 1200, replace = TRUE)
hist(dice1200, prob=T, breaks=c(0:6), ylim = c(0, 0.3), main = "(c) n=1200")
abline(b=0, a=1/6, col=2)
dice12000 = sample(1:6, 12000, replace = TRUE)
hist(dice12000, prob=T, breaks=c(0:6), ylim = c(0, 0.3), main = "(d) n=12000")
abline(b=0, a=1/6, col=2)
