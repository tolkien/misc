lotto <- function(nn = 10000) { # lotto.r
  luckyNo <- c(1,2,3,4,5,6)   # ��÷��ȣ
  threeNo <- 0                # ��ȣ �� ���� �´� ȸ��
  for (i in 1: nn) {          # nn �� ���ǽ���
     x <- sort(sample.int(45, size=6))  # 1���� 45������ ���� 6�� �����Ͽ� ��������
     nMatch = 0
     for (j in 1:6) {  # ���� �ζǹ�ȣ x ���� ����
       for(k in j:6) { # ��÷��ȣ LuckNo�� ������ ��
         if (x[j] == luckyNo[k]) nMatch = nMatch +1 # �� ��ȣ�� ��÷��ȣ�� ��
     }} # end for j & k
     if (nMatch == 3) threeNo = threeNo + 1 # �� ���� ��ȣ�� ��ġ�� Ƚ��
  } # end for i
list(threeNo = threeNo)
}  # end function
