# ��ǥ�� ���� �߷�
 xx <- 36; nn <- 80; phat <- xx/nn ;  p0 <- 0.4 
 z0 <- (phat-p0)/sqrt(p0*(1-p0)/nn)
 z0
 2*(1-pnorm(abs(z0)))
 lbd <- phat - qnorm(.975)*sqrt(phat*(1-phat)/nn) 
 ubd <- phat + qnorm(.975)*sqrt(phat*(1-phat)/nn) 
 c(lbd, ubd)

# ��ǥ�� ���� �߷�

 x1 <- 28; n1 <- 35; p1 <- x1/n1
 x2 <- 8; n2 <- 45; p2 <- x2/n2
 p <- (x1 + x2) / (n1+n2)
 z0 <- (p1-p2)/sqrt( p1*(1-p1)* (1/n1 +  1/n2) )

# z0 <- (p1-p2)/sqrt( p1*(1-p1)/n1 +  p2*(1-p2)/n2 )
# �� ���� ������ ��Ÿ������ ������

 z0
 2*(1-pnorm(abs(z0)))
 lbd <- p1-p2 - qnorm(.975)*sqrt( p1*(1-p1)/n1 +  p2*(1-p2)/n2 )
 ubd <- p1-p2 + qnorm(.975)*sqrt( p1*(1-p1)/n1 +  p2*(1-p2)/n2 )
 c(lbd, ubd)


# ��ǥ�� ���� �߷� / with prop.test �Լ�

 prop.test(xx, nn, p=0.4, correct=F)

 x <- matrix(c(36, 44), ncol=2)
 prop.test(x, correct=F, p=0.4) 

# ��ǥ�� ���� �߷� / with prop.test �Լ�
 x <- matrix(c(28, 7, 8, 37), byrow=T, ncol=2)
 prop.test(x, correct=F)
