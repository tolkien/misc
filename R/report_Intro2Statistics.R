#p66, Q21 plot
high_temp = c(29,29,34,35,35,31,32,34,38,34,33,31,31,30,34,35,
              34,32,32,29,28,30,29,31,29,28,30,29,29,27,28)
#names(high_temp) = c(1:31)
#jpeg("p66.jpg")
hist(high_temp, main="high temperature")
dotchart(high_temp, main="high temperature of August")
stem(high_temp)
#dev.off()

#p104, Q19 두그룹 모평균 비교검정
player_A = c(198,119,174,235,134,192,124,241,158,176)
player_B = c(196,159,162,178,188,169,173,183,177,152)
# H0: u_a - u_b = D_0, H1: u_a - u_b != D_0
shapiro.test(player_A)
shapiro.test(player_B)
var.test(player_A, player_B)
t.test(player_A, player_B, alternative = c("two.sided"),
       var.equal = T)

# by manual
X_A = mean(player_A)
X_B = mean(player_B)
n_A = length(player_A)
n_B = length(player_B)
S_A = var(player_A)
S_B = var(player_B)
T = (X_A - X_B)

#p229, Q11 한그룹 모평균 비교
height=c(154,154,186,243,159,174,183,163,192,181)

#p285, Q14 paired t-test
before=c(8,12,5,4,6,3,4,3,2,6,6,9)
after =c(5,3,2,1,4,2,2,4,3,5,4,3)
location=c("A","B","C","D","E","F","G","H","I","J","K","L")
names(before)=location
st_light=rbind(before, after)

#p286, Q17 one-way factorial design, ANOVA
corex=c("A1","A2","A3","A4","A5")
B1=c(79,72,51,58,68)
B2=c(75,66,48,56,65)
B3=c(69,64,44,51,61)
B4=c(65,62,41,45,58)
names(B1)=corex
koks=rbind(B1,B2,B3,B4)

#p332, Q13 산점도 상관계수 회귀모형 + plot
used_year =c(1.0,1.5,2.0,2.0,2.0,3.0,3.0,3.2,4.0,4.5,5.0,5.0,5.5)
used_price=c(4.5,4.0,3.2,3.4,2.5,2.3,2.3,2.3,1.6,1.5,1.0,0.8,0.4)
used_car=rbind(used_year,used_price)
