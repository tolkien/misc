# chisq.test.r

#  Frequency table
 frq <- c(19, 16,19,18, 14, 14)
 pp <- rep(1/6, 6)
 efrq <- pp*sum(frq) 
 chi0 <- sum ( (frq-efrq)^2/efrq )
 chi0
 1-pchisq(chi0, 5)

# Cross table

 obs <- matrix(c(20,30,15,30,20,15), ncol=3, byrow=T)
 nrow <- dim(obs)[1] ; ncol <- dim (obs)[2]  # ��� ���� ���� ���
 csum <- apply(obs, 2, sum)                  # ���� ��
 rsum <- apply(obs, 1, sum)                  # ���� ��
 ecount <- matrix(0, nrow, ncol)             # ��� ���� ������ ��� �ʱ�ȭ

 tsum <- sum(rsum)                           # ��ü��   
 ecount <- rsum %*% t(csum) /tsum            # ��� ����

 chi0 <- sum( (obs-ecount)^2/ecount )
 chi0
 1-pchisq(chi0, (nrow-1)*(ncol-1))

#==============================================
 chisq.test(frq)

 chisq.test(obs)

 chisq.test(table(sample(1:6, size=100, replace=T)))
