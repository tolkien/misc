# change working directory to R.2020.1
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2020.1'))
}

# det(A) == |A| : 행렬식 [ad - bc]
# 기저(basis), 가우스 소거법
# https://ko.wikipedia.org/wiki/고윳값과_고유_벡터#계산_실례
# https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors
# 가우스 소거법: https://suhak.tistory.com/295
# eigen value(고유값): https://darkpgmr.tistory.com/105

# https://darkpgmr.tistory.com/103
# 고유값(eigenvalue)과 고유벡터(eigenvector), 대각화,
# 특이값분해(SVD, singular value decomposition)를 포함하여
#  pseudo-inverse, 케일리-해밀턴 정리, 행렬식(determinant),
#  최소자승법(least-square)과 선형연립방정식의 풀이,
#  주성분분석(principal component analysis), 2차곡선의 행렬표현 

# A, I, E, t(A) = a_ji, A^-1 = (1/(ad-bc))(d -b: -c a)
# tr(A) = a + d, tr(AB) = tr(BA)
# det(A) = ad-bc, det(AB) = det(A)det(B)
# det(AB) = det(BA), det(A)det(A^-1) = 1, det(A) != 0 <=> A^-1 exist
# eigen value for A: the value of k if det(A-kE) = 0
# eigen vector, similar transformation
# Cayley-Hamilton's Theorem: A^2 - tr(A)A + det(A)E = 0
