binom.par <- function(nrep=100, n=5, p=1/6) { # binom.par.r
   x <- rbinom(nrep, n, p)     # B(n,p)���� nrep ���� ���� ����
   meanx <- mean(x)            # �̵� ������ ���
   varx <- var(x)              # �̵� ������ �л�
   list(meanx = meanx, varx = varx)
} # end function

binom.par()
