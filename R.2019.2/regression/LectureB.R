# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# if  Y !~ N(u, s^2)
# use "generalized linear model (GLM)" when Y ~ exponential family distribution
# 이항, 포와송, 감마, 음이항, 역정규분포, 정규분포 by Nelder & Wedderburn (1972)
# a. 반응변수 분포, b. 선형예측자, c. 연결함수
glider = read.csv("./data/sugar_glider_binomial.csv")
head(glider, 3)
glider.glm = glm(occurr ~ p_size_km + con_metric, family=binomial(link=logit), data=glider)
summary(glider.glm)
# 모형의 유의성 검정. p-value
1-pchisq(68.994 - 54.661, 2)
# or anova()
glider.glm0 = glm(occurr ~ 1, family=binomial(link=logit), data=glider)
anova(glider.glm0, glider.glm, test="Chisq")
# 모형의 적합도 검정. p-value
1-pchisq(54.661, 47)
# or (residual deviance / degree of freedom < 2)
54.661/47
# 모형의 선택: anova 방법
glider.glm2 = glm(occurr ~ p_size_km, family=binomial(link=logit), data=glider)
summary(glider.glm2)
anova(glider.glm2, glider.glm, test = "Chisq")
# 모형의 선택: AIC 방법
AIC(glider.glm2, glider.glm)
# 모형의 선택: 변수선택방법
library(MASS)
stepAIC(glider.glm, direction="both")
# 로지스틱회귀모형의 해석
p_size = seq(20, 230, 1)
hat_est = predict(glider.glm2, list(p_size_km = p_size), type="link")
par(mfrow=c(1,1))
plot(p_size_km, occurr, xlab="(x)", ylab="hat pi(x) occur", sub="(a)", pch=20)
glider_g = read.csv("./data/sugar_glider_binomial_g.csv")
head(glider_g, 3)
y = cbind(glider_g$cases, glider_g$count - glider_g$cases)
glider_g.glm = glm(y ~ glider_g$p_size_med, family=binomial(link=logit))
summary(glider_g.glm)
