draw.chisq <- function() { # draw.chisq.r
  from <-0    # x�� ����
  to <- 20    # x�� ����
  x <- seq(from, to, length=100)  # x���� ��
  plot(x, dchisq(x, 3), type="l", col="red", 
     main=expression(chi[nu]^2), 
     ylab=expression(f(x)) )   # ������ 3�� ī������
  curve(dchisq(x, 5), from=from, to=to, lty=2, add=T, 
     col="blue")               # ������ 5�� ī������ ����
  curve(dchisq(x, 10), from=from, to=to, lty=3, add=T, 
     col="magenta")            # ������ 10�� ī������ ����
  abline(h=0)                  # x�� �׸���
  legend("topright", lty=1:3, col=c("red", "blue", "magenta"),
     legend=c(expression(nu == 3),expression(nu == 5),
     expression(nu == 10)) )   # ���ʸ����
} # end function

