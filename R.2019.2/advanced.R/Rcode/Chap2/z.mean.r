z.mean <- function(nn=10, nrep=1000) { #z.mean.r
  xbar <- rep(0, nrep)    # nrep ���� ����� ������ �迭
  stdev <- sqrt(5)        # ǥ������ 
  for (i in 1:nrep) {     # nn ���� ����� nrep�� ���
    xbar[i] <- mean(rnorm(nn, 0, stdev))
  } # nrep ���� ����� ���
  list(meanxbar= mean(xbar), varxbar=var(xbar))
} # end function

