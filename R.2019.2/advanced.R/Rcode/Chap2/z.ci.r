z.ci <- function(alpha = 0.05, nrep = 1000) { #z.ci.r
  ndata <- 10                 # �ŷڱ����� ����� �ڷ��� �� 
  qz <-  qnorm(1-alpha/2)     # 
  se <- 1/sqrt(ndata)         # 
  ncover <- 0                 # �ŷڱ����� 0�� �����ϴ� ȸ��
  for (i in 1:nrep) {         # nrep �� (�⺻�� 1000��) �ݺ�
    x <- rnorm(ndata)         # ndata ��(�⺻�� 10��)�� ���� ����
    meanx <- mean(x)          # ndata ���� ���
    ubound <- meanx + qz*se   # �ŷڻ���
    lbound <- meanx - qz*se   # �ŷ�����
    if ( ubound > 0 & lbound < 0) ncover = ncover + 1 # �ŷڱ����� ���ԵǴ� ����
  } # end for
  list(ncover=ncover)  # ���
} # end function

z.ci()

