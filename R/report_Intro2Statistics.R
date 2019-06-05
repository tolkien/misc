#p66, Q21 plot
high_temp = c(29,29,34,35,35,31,32,34,38,34,33,31,31,30,34,35,
              34,32,32,29,28,30,29,31,29,28,30,29,29,27,28)
#names(high_temp) = c(1:31)
jpeg("p66_hist.jpg")
hist(high_temp, main="high temperature")
dev.off()
jpeg("p66_dot.jpg")
dotchart(high_temp, main="high temperature of August")
dev.off()
stem(high_temp)

#p104, Q19 두그룹 모평균 비교검정
player_A = c(198,119,174,235,134,192,124,241,158,176)
player_B = c(196,159,162,178,188,169,173,183,177,152)
# H0: u_a - u_b = D_0, H1: u_a - u_b != D_0
# data의 정규성 test
#shapiro.test(player_A)
#shapiro.test(player_B)
# varience가 차이가 나는가?
var.test(player_A, player_B)
# 분산이 다르니까 var.equal=F
t.test(player_A, player_B, var.equal = F)

# by manual
X_A = mean(player_A)
X_B = mean(player_B)
n_A = length(player_A)
n_B = length(player_B)
S_A = var(player_A)
S_B = var(player_B)
F = S_A/S_B
F_a2 = qf(1-0.05/2, n_A - 1, n_B - 1)
F > F_a2

S_df = (S_A/n_A + S_B/n_B)^2 / ( (S_A/n_A)^2/(n_A - 1) + (S_B/n_B)^2/(n_B - 1))
T = (X_A - X_B)/sqrt(S_A/n_A + S_B/n_B)
T_a2 = qt(1-0.05/2, S_df)
T > T_a2

#p229, Q11 한그룹 모평균 비교
# 모평균 가설검정?
height=c(154,154,186,243,159,174,183,163,192,181)

t.test(height, mu=160, alternative = "greater", conf.level = 0.95)

#p285, Q14 paired t-test
before=c(8,12,5,4,6,3,4,3,2,6,6,9)
after =c(5,3,2,1,4,2,2,4,3,5,4,3)

t.test(before, after, paired = TRUE)

#p286, Q16 one-way factorial design, ANOVA
com_A=data.frame(rep('A', 7), c(69, 67, 65, 59, 68, 61, 66))
com_B=data.frame(rep('B', 6), c(56, 63, 55, 59, 52, 57))
com_C=data.frame(rep('C', 5), c(71, 72, 70, 68, 74))
com_label=c('company', 'value')
names(com_A)=com_label
names(com_B)=com_label
names(com_C)=com_label
satisfy = rbind(com_A, com_B, com_C)
require(ggplot2)
ggplot(satisfy, aes(x = company, y = value)) +
  geom_boxplot(fill = "grey80", colour = "blue") +
  scale_x_discrete() + xlab("Company") +
  ylab("satisfy index")
m_3 = lm(value ~ company, data=satisfy)
summary(m_3)
anova(m_3)
m_4 = aov(value ~ company, data=satisfy)
summary(m_4)

#p332, Q13 산점도 상관계수 회귀모형 + plot
used_year =c(1.0,1.5,2.0,2.0,2.0,3.0,3.0,3.2,4.0,4.5,5.0,5.0,5.5)
used_price=c(4.5,4.0,3.2,3.4,2.5,2.3,2.3,2.3,1.6,1.5,1.0,0.8,0.4)
used_car=rbind(used_year,used_price)
df_332 = as.data.frame(used_car)
m1 = lm(used_year~used_price, data = df_332)
summary(m1)
plot(used_year~used_price, data = df_332)
abline(m1, col="blue")
