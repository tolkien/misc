# corr.test.r
 x <- c(35,35,33,34,31,35,35,35,35,35,33,35,35,35,31,32,35)
 y <- c(25,31,33,33,34,33,34,33,29,33,35,35,35,35,35,35,32)

 rr <- cov(x, y)/(sd(x)*sd(y)) # �Ǵ�   rr <- cor(x, y)
 z0 <- 0.5*log((1+rr)/(1-rr)) / sqrt(1/14)
 2*(1-pnorm(abs(z0)))  # ����Ȯ��
 nul <- 0.5*log((1+rr)/(1-rr)) -qnorm(0.975)*sqrt(1/14)
 nuu <- 0.5*log((1+rr)/(1-rr)) +qnorm(0.975)*sqrt(1/14)
 lbd <- (exp(2*nul)-1)/(exp(2*nul)+1)
 ubd <- (exp(2*nuu)-1)/(exp(2*nuu)+1)
 c(lbd, ubd)

 t0 <- rr*sqrt(15)/sqrt(1-rr^2)
 t0  # ������跮 �μ�
 2*(1-pt(abs(t0), 15))  # ����Ȯ��
