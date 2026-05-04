#################################################################################
#### Elements de corrigé du TP2
#################################################################################

setwd("/Users/sarahlemler/Documents/Enseignements/EnseignementCentrale/StatAvancees2A/StatAvancées2024/TP/TP2") # à personnaliser
rm(list=objects()) # nettoyer l'environnement
graphics.off()

############################
#### 1. Regression lineaire
############################
###
### 1.1 Acquérir les données
###
#install.packages("lasso2")
#library(lasso2)
Prostate<-read.table("Prostate.txt",sep=";",header=T,dec=".")
#data(Prostate)

dim(Prostate) #97  9

head(Prostate)  # les premieres lignes
str(Prostate)   # type numerique pour chaque variable

###
### 1.2 Analyse uni- et bi-variee
###

summary(Prostate)    # qqs statistiques sur chaque colonne
apply(Prostate,2,mean) # moyenne pour chaque colonne
apply(Prostate,2,sd) # ecart type pour chaque colonne

apply(Prostate,2,function(x){c(mu=mean(x),sd=sd(x))}) #moyenne et ecart type pour chaque colone
#lcavol   lweight       age      lbph       svi        lcp   gleason    pgg45     lpsa
#mu 1.350010 3.6526864 63.865979 0.1003556 0.2164948 -0.1793656 6.7525773 24.38144 2.478387
#sd 1.178625 0.4966307  7.445117 1.4508066 0.4139949  1.3982496 0.7221341 28.20403 1.154329

pairs(Prostate)       #scatter plot

# matrice de correlation
round(cor(Prostate),3)
#lcavol lweight   age   lbph    svi    lcp gleason pgg45  lpsa
#lcavol   1.000   0.194 0.225  0.027  0.539  0.675   0.432 0.434 0.734
#lweight  0.194   1.000 0.308  0.435  0.109  0.100  -0.001 0.051 0.354
#age      0.225   0.308 1.000  0.350  0.118  0.128   0.269 0.276 0.170
#lbph     0.027   0.435 0.350  1.000 -0.086 -0.007   0.078 0.078 0.180
#svi      0.539   0.109 0.118 -0.086  1.000  0.673   0.320 0.458 0.566
#lcp      0.675   0.100 0.128 -0.007  0.673  1.000   0.515 0.632 0.549
#gleason  0.432  -0.001 0.269  0.078  0.320  0.515   1.000 0.752 0.369
#pgg45    0.434   0.051 0.276  0.078  0.458  0.632   0.752 1.000 0.422
#lpsa     0.734   0.354 0.170  0.180  0.566  0.549   0.369 0.422 1.000

library(corrplot)
corrplot(cor(Prostate))
# lpsa semble correlee positivement avec lcavol, svi et lcp, mais sans doute pas avec lbph. 
# lpsa ne semble pas avoir de correlations negatives avec d'autres covariables.
# certaines variables explicatives semblent correlees entre elles : lcp et lcavol par exemple.
# Un calcul de la matrice de correlation permet d'obtenir des donnees chiffrees sur ces constatations
# visuelles. 


###
### 1.3 Modeliser
###
# Hypotheses standard de la regression lineaire multiple
# lpsa_i= beta_0 + beta_1 x lcavol_i+ beta_2 x lweight_i+ beta_3 x age_i+ beta_4 x lbph_i 
#+ beta_5 x svi_i + beta_6 x lcp_i + beta_7 x gleason_i + beta_8 x pgg45_i +  eps_i
# eps=(eps_1,...,eps_n) est un vecteur gaussien d'esperance nulle
# et de variance sigma^2 Id_n
# le parametre beta=(beta_0, beta_1, beta_2, beta_3, beta_4, beta_5, beta_6, beta_7, beta_8) est 
#de dimension 9, le modele est identifiable
# ici, n=97, p=9

###
### 1.4 Estimer : calcul a la main
###
X=as.matrix(Prostate[,1:8])
X=cbind(intercept=1,X)           # intercept


Y=as.matrix(Prostate$lpsa,ncol=1)
beta.est=solve(t(X)%*%X)%*% t(X)%*%Y
# intercept  0.669399027
#lcavol     0.587022881
#lweight    0.454460641
#age       -0.019637208
#lbph       0.107054351
#svi        0.766155885
#lcp       -0.105473570
#gleason    0.045135964
#pgg45      0.004525324

n=length(Y)
p=ncol(X)
sigma.est=sqrt(sum( (X%*%beta.est -Y)^2   )/(n-p)) #   0.7084164 estimateur de l'écart type sigma
ddl=n-p #88
V= solve(t(X)%*%X) *sigma.est^2 # estimateur de Var(\hat\beta)
stddev=sqrt(diag(V))
# intercept      lcavol     lweight         age        lbph         svi         lcp     gleason 
# 1.296381277 0.087920374 0.170012071 0.011172743 0.058449332 0.244309492 0.091013484 0.157464467 
#pgg45 
# 0.004421185 
beta.est/stddev  # T value du test beta_j=0 contre beta_j!=0
# intercept  0.5163597
# lcavol     6.6767560
# lweight    2.6731081
# age       -1.7575995
# lbph       1.8315753
# svi        3.1360054
# lcp       -1.1588785
# gleason    0.2866422
# pgg45      1.0235545

alpha=0.05; qt(1-alpha/2,ddl) #1.98729 pour le test bilateral

2*pt(-abs(beta.est/stddev),n-p)
2*pt(abs(beta.est/stddev),n-p,lower.tail=FALSE) #if TRUE : P[X ≤ x],if FALSE : P[X > x].
#intercept 6.068984e-01
#lcavol    2.110634e-09
#lweight   8.956206e-03
#age       8.229321e-02
#lbph      7.039819e-02
#svi       2.328823e-03
#lcp       2.496408e-01
#gleason   7.750601e-01
#pgg45     3.088513e-01

# beta_lcavol=0 contre  beta_lcavol\neq 0  on rejette H0: lcavol est significative,
# p-valeur très petite (<< 0.05),  
# il faut garder la variable lcavol dans le modele pour explique lpsa
# beta_lcp=0 contre  beta_lcp\neq 0  on garde H0: lcp n'est pas significatif,
# il n'est pas utile de retenir lcp dans le modele
# Pour un test de niveau 5%, il ne semble pas qu'il faille conserver les variables age,lbph, gleason
# et pgg45, mais certaines p-valeurs sont quand même assez proche de la valeur 0.05 comme par exemple
# pour age ou lbph

# valeur moyenne du lpsa pour les valeurs de covariables de la deuxieme observation
X[2,]%*%beta.est   # 0.7240557  \hat{Y}_2=\hat\beta X_2
X%*%beta.est       # estimation du lpsa pour chaque observation \hat{Y}=\hat\beta X

###
### 1.5 Estimation avec la fonction lm
###
#lm(lpsa ~ lcavol + lweight + age + lbph + svi + lcp + gleason + pgg45, data=Prostate)
model8=lm(lpsa~.,data=Prostate)
#model8=lm(lpsa~-1+.,data=Prostate)
summary(model8)
#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)  0.669399   1.296381   0.516  0.60690    
#lcavol       0.587023   0.087920   6.677 2.11e-09 ***
#lweight      0.454461   0.170012   2.673  0.00896 ** 
#age         -0.019637   0.011173  -1.758  0.08229 .  
#lbph         0.107054   0.058449   1.832  0.07040 .  
#svi          0.766156   0.244309   3.136  0.00233 ** 
#lcp         -0.105474   0.091013  -1.159  0.24964    
#gleason      0.045136   0.157464   0.287  0.77506    
#pgg45        0.004525   0.004421   1.024  0.30885    
#Residual standard error: 0.7084 on 88 degrees of freedom
#Multiple R-squared:  0.6548,	Adjusted R-squared:  0.6234 
#F-statistic: 20.86 on 8 and 88 DF,  p-value: < 2.2e-16

names(model8)

# Estimate: valeur estimee du parametre
beta= model8$coef
beta

# Std Error: racine carree de la variance de l'estimation de chaque composante
V=vcov(model8)      # matrice de variance-covariance estimée de l'estimateur de beta
s=sqrt(diag(V))     # attention a l' e.t. de l'intercept

# t-value: valeur de la statistique de student du test beta_j=0 contre beta_j<>0
tobs=model8$coeff/s 

# colonne Pr(>|t|): p-value du test precedent

# erreur standard résiduelle = estimation de sigma
sqrt(sum((Prostate$lpsa-model8$fitted)^2)/model8$df.residual) #0.7084164
summary(model8)$sigma #idem

#F-statistic : valeur de la statistique de Fisher du test de significativité globale
#beta1=beta2=...=beta8=0 contre l'un des paramètres est non nul
#88=n-p=97-9 et 8=p-1 (modèle complet-modèle sans covariable)

# valeurs ajustees: plusieurs moyens
data.frame(model8$fitted[2],predict(model8,newdata=Prostate[2,]),X[2,]%*%beta.est)
data.frame(fitted=model8$fitted,predict=predict(model8),XBetaEst=X%*%beta.est)

predict(model8)
###
### 1.6 Intervalle de confiance
###

### IC de theta
alpha=0.05
qt=qt(1-alpha/2,model8$df.residual)
IC=data.frame(mean=beta.est, 
              min= beta.est-qt*sqrt(diag(V)) , 
              max= beta.est+qt*sqrt(diag(V)))
#              mean          min         max
#intercept  0.669399027 -1.906886346 3.245684401
#lcavol     0.587022881  0.412299613 0.761746149
#lweight    0.454460641  0.116597375 0.792323906
#age       -0.019637208 -0.041840687 0.002566271
#lbph       0.107054351 -0.009101413 0.223210115
#svi        0.766155885  0.280642108 1.251669662
#lcp       -0.105473570 -0.286343744 0.075396605
#gleason    0.045135964 -0.267791575 0.358063503
#pgg45      0.004525324 -0.004260852 0.013311499

confint(model8)   #idem
# 0 appartient a l'IC de age, age n'est pas significatif
# 0 n'appartient pas a l'IC de lcavol, lcavol est significatif

### IC de l'esperance sous une condition d'experience
predict(model8,newdata=data.frame(lcavol=0.75, lweight=3.43, age=62, lbph=-1.39, svi=0, lcp=-1.39, 
                                  gleason=6, pgg45=0),interval="confidence")
#       fit     lwr      upr
#    1.719578 1.45585 1.983305

# calcul direct
x0=matrix(c(1,0.75,3.43,62,-1.39,0,-1.39,6,0),ncol=p,nrow=1)
y0.chap=x0%*%beta.est
v0.chap= x0%*%V%*%t(x0)

data.frame(mean=y0.chap, min= y0.chap-qt*sqrt(v0.chap) ,  
           max= y0.chap+qt*sqrt(v0.chap)) #idem

### IP intervalle de prevision d'une valeur individuelle
predict(model8,newdata=data.frame(lcavol=0.75, lweight=3.43, age=62, lbph=-1.39, svi=0, lcp=-1.39, 
        gleason=6, pgg45=0),interval="prediction")
#fit       lwr      upr
#1.719578 0.2872602 3.151895
# IP est plus large, c'est normal, puisque la variabilite du phenomene observe s'ajoute a
# celle due a l'echantillonnage


###
### 1.7 Tester
###
### significativite globale a partir de Fisher

# test de fisher de H0: modele iid (beta1=beta2=beta3=beta4=beta4=beta5=beta6=beta7=beta8=0) 
# contre modele complet (beta1<>0 ou beta2<>0 ou beta3<>0 ou beta4<>0 ou beta5<>0 ou beta6<>0 ou
# beta7<>0 ou beta8<>0)
# la statistique de test F=[SCM/(p-1)]/[SCR/(n-p)] ~ Fisher(p-1=9-1=8,n-p=97-9=88)
# R={F>qf(0.95,8,88) }
# la valeur observee de F = 20.8 > qf(0.95,p-1,n-p)=2.04 donc on rejette le modele iid 
# avec un risque de premiere espece de 5%. 
# On peut aussi comparer la pvalue= 2.2e-16 <0.05, meme decision


SCRH0= sum( (Prostate$lpsa-mean(Prostate$lpsa))^2)
SCRH1=  sum(model8$resid^2  )
F= ((SCRH0-SCRH1)/(p-1))/(SCRH1/(n-p))  # 20.86129
qf(1-alpha,p-1,model8$df)  #2.04 donc F>qf donc on est dans la zone de rejet 
pf(F,p-1,model8$df,lower.tail=FALSE) # 2.244848e-17<0.05 p-value=P(Fisher>F)

# F-statistic: 20.9 on a 8 and 88 DF,  p-value: < 2.2e-16, test très significa

anova(lm(lpsa~1,data=Prostate),model8)
#Model 1: lpsa ~ 1
#Model 2: lpsa ~ lcavol + lweight + age + lbph + svi + lcp + gleason + pgg45
#     Res.Df     RSS        Df    Sum of Sq      F        Pr(>F)    
#1     96       127.918                                 
#2     88        44.163     8      83.755     20.861    < 2.2e-16 ***

# une ligne par modele
# Res.Df: n-pj ou j est le modele 1 ou 2 et pj sa dimension
# RSS: Residual Sum of Square: Somme des Carres Residuels pour le modele considere 
# RSS=sum((x_i-mean(x_i))^2)
# Df: Degree of Freedom: p2-p1
# Sum of Sq: somme des carres modeles: RSS_1-RSS_2
# F=( (RSS_1-RSS_2)/(Df Sum_2) )/ ( RSS_2/ Res.Df_2 )

### test d'inclusion
model1=lm(lpsa~lcavol,data=Prostate)
summary(model1)
anova(model1,model8)
((58.915-44.163)/7  )/ ( 44.163/88 ) # 4.199301

anova(model8) #permet de faire tous les tests de Fisher modèle à 1 variable contre modèle complet


lmf=lm(lpsa~lcavol+lweight+svi,data=Prostate)
anova(lmf,model8)
# test de Fisher de sous-modele entre H0: M2 (beta_3=beta_4=beta_6=beta_7=beta_8=0) contre H1 M 
# (beta_3<>0 ou beta_4<>0 ou beta_6<>0 ou beta_7<>0 ou beta_8<>0)
# sous H0, la stat de Fisher suit une loi de Fisher de parametres (9-4=5, n-p=88)
# la pvalue observee vaut 0.2167 > 5%, donc on conserve M2 avec un risque de seconde espece inconnu 
# les variables age,lbph,lcp,gleason et pgg45 ne sont pas significatives

library(MASS)
stepAIC(model8)
###
### 1.8 Valider
###

# fenetre en 2x2,  marge haute pour titre general
par(mfrow=c(2,2), oma=c(0,0,2,0)) 


# graphe des ajustes/ observes
plot(lmf$fitted,Prostate$lpsa,main="ajustes/observes") #Y en fonction de hat(Y)
abline(0,1)

# graphe des differents residus
plot(lmf$fitted,lmf$residuals,main="differents residus",ylim=c(-3,3))# non normes
library(MASS) # pour la fonction stdres
points(lmf$fitted,stdres(lmf), col=2,pch=2 )# fitted to variance 1
points(lmf$fitted,studres(lmf),col=3,pch=3) #studentises par validation croisee
abline(h=2)
abline(h=-2)
legend("bottomright",c("resid", "stdres", "studres"),col=1:3, pch=1:3,cex=0.5)

# graphe quantile/quantile
qqnorm(studres(lmf),main="graphe quantile-quantile")
qqline(stdres(lmf))

# titre general (noter outer=TRUE)
title(main="Validation en regression lineaire multiple", outer=TRUE)

# les residus bruts sont tres faibles parce que les valeurs observees
# sont elles-memes proches de 0 et estimeees avec une grande precision.
# les residus studentises ne montrent pas de dependance ou de tendance, 
# ils sont raisonnablement compris entre -2 et 2

## la fonction plot
par(mfrow=c(2,2))
plot(lmf)


plot(lmf, caption = list("Residuals vs Fitted", "Normal Q-Q",
                          "Cook's distance",
                         "Residuals vs Leverage",expression("Cook's dist vs Leverage  " * h[ii] / (1 - h[ii]))))
#cooks.distance(lmf)

# graphe resid vs leverage : pour determiner les points influents,
# ie q i la tendance de la majorite des observations.
# On cherche des points dans les cadrans en haut- droit ou bas-droit
# (fort residu ET fort levier ET grande distance de Cook).
# (p_ii/(1-p_ii))  ou p_ii est la diagonale de la matrice de projection
# indique la force de levier. La distance de Cook est d'autant plus grande que
# la suppression du point considere modifie les resultats de la regression 
# cf https://www.rdocumentation.org/packages/stats/versions/3.5.1/topics/plot.lm

stepAIC(model8,direction='both',trace=1)
stepAIC(model8,k=log(n),trace=0)

library(leaps)
recherche=regsubsets(lpsa~.,int=TRUE,nbest=1,
                     nvmax=10,
                     method="exhaustive",data=Prostate)

#,oma=c(0,0,0,0))
#pdf("FigRegsubset.pdf")
par(mfrow=c(1,1))
plot(recherche,scale="bic",xlab="Nombre de variables",ylab="BIC",main='BIC')
plot(recherche,scale="Cp",xlab="Nombre de variables",ylab="Cp",main='Cp')
plot(recherche,scale="adjr2",xlab="Nombre de variables",ylab="adjR2",main='adjR2')
plot(recherche,scale="r2",xlab="Nombre de variables",ylab="R2",main='R2')

par(mfrow=c(1,1))#,oma=c(1,1,1,1))
plot(summary(recherche)$bic,xlab="Nombre de variables",ylab="BIC",main='BIC')
plot(summary(recherche)$cp,xlab="Nombre de variables",ylab="Cp",main='Cp')
plot(summary(recherche)$rsq,xlab="Nombre de variables",ylab="R2",main='R2')
plot(summary(recherche)$adjr2,xlab="Nombre de variables",ylab="adjR2",main="adjR2")
plot()

################################
### 2. Une analyse de covariance
################################

###
### 2.1 Acquérir les données
###
rm(list=objects()); graphics.off()
perf=read.table("perfusion.txt",header=TRUE, row.names=1,skip=1)
head(perf)
dim(perf) # 96 observations
n=dim(perf)[1]

table(perf$systeme,perf$debit) # 3 pour chaque couple, 3 mesures pour chaque système et chaque débit
tapply(perf$delai, list(perf$systeme, perf$debit),mean)
#         2.5         5       7.5       10     12.5       15       20       25
# S1 1985.000  993.3333  620.3333 443.6667 355.6667 297.3333 240.0000 190.0000
# S2 2783.333 1375.0000  906.6667 683.3333 571.6667 506.6667 340.0000 273.3333
# S3 3451.667 1671.6667 1121.6667 833.3333 676.6667 593.3333 463.3333 380.0000
# S4 1980.000  965.0000  616.6667 436.6667 355.0000 293.3333 246.6667 193.3333 

###
### 2.2 Analyser
###

library(lattice)
xyplot(delai~debit|systeme,data=perf) 

perf$invdebit=1/perf$debit #permet de se ramener a des choses lineaire
par(mfrow=c(1,1))
plot(perf$invdebit,perf$delai,col=c(1:4),
     pch=c(1:4),
     main="Temps d'alarme de differents systemes de perfusion",
     xlab="inverse du debit",ylab="delai avant l'alarme")
legend("topleft",c("S1","S2","S3","S4"),pch=c(1:4),col=c(1:4))

###
### 2.3 Modéliser : modèle ANCOVA
###
# Y_{ik}=(mu+a_k) + (beta+b_k)* invdebit + eps_{ik} 
# E(eps| X )= 0 ; var(epsi| X)=\sigma^2 Id_n 
# + gaussien si on veut des lois exactes
# CI: coefficient du premier niveau du facteur mis a zero 

###
### 2.4 Estimer 
###

Mg=lm(delai~systeme*invdebit,data=perf)
summary(Mg)
#                          Estimate Std. Error t value Pr(>|t|)    
#(Intercept)              -33.53225    7.88743  -4.251 5.27e-05 *** 
#systemeS2                 37.17563   11.15451   3.333 0.001259 ** 
#systemeS3                 40.41060   11.15451   3.623 0.000487 ***
#systemeS4                 -0.08376   11.15451  -0.008 0.994026    
#perf$invdebit           5040.73955   45.28203 111.319  < 2e-16 ***
#systemeS2:perf$invdebit 1885.29121   64.03846  29.440  < 2e-16 ***
#systemeS3:perf$invdebit 3498.17622   64.03846  54.626  < 2e-16 ***
#systemeS4:perf$invdebit  -35.51081   64.03846  -0.555 0.580627
#
# Residual standard error: 24.75 on 88 degrees of freedom
# Multiple R-squared: 0.999,  Adjusted R-squared: 0.999 
# F-statistic: 1.297e+04 on 7 and 88 DF,  p-value: < 2.2e-16 

#Mg=lm(delai~systeme*invdebit,data=perf,contrasts=list(systeme="contr.SAS")) #(S4 pris comme 
# reference sur sur SAS )

#Mg=lm(delai~systeme*invdebit,data=perf,contrasts=list(systeme="contr.sum")) # contrainte sur la
# somme des paramètres (sum(a_i)=0, sum(b_i)=0)

# new.systeme <- relevel(perf$systeme,"S2") # permet de prendre "S2" comme référence
#lm(delai~new.systeme*invdebit, data=perf)



#Regression globalement significative, R^2 proche de 1
anova(Mg)


co=Mg$coeff
abline( co[1],co[5],col=1) #correspond aux estimations pour S1, a1=0 et beta1=0
##co[1]=hat(mu) ordonnée à l'origine et co[5]=hat(beta) pente 
for (i in 2:4) abline( co[1]+co[i],co[5]+co[4+i],col=i)

attach(perf)
Mgbis<-lm(delai~systeme+systeme:invdebit,data=perf)
#Mgbis<-lm(delai~systeme:invdebit-1,data=perf)
summary(Mgbis)
anova(Mgbis)


### 
### 2.5 Valider
###

library(MASS)
plot(perf$invdebit,studres(Mg),
     col=c(1:4))
abline(h=2,lty=2); abline(h=-2,lty=2)

qqnorm(studres(Mg),main="graphe quantile-quantile")
abline(0,1)
shapiro.test(studres(Mg))
# W = 0.979, p-value = 0.1263
#on ne rejette pas H0, loi normale pour les residus



###
### 2.6 Tester des sous-modèles
###

M0=lm(delai~invdebit,data=perf);
summary(M0)
sqrt(sum((M0$fitted-perf$delai)^2)/(length(perf$debit)-2) ) #274.3625 94 estimateur de sigma
#Coefficients:
#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)   -14.16      43.71  -0.324    0.747    
#invdebit     6377.73     250.95  25.415   <2e-16 ***
#Residual standard error: 274.4 on 94 degrees of freedom
#Multiple R-squared: 0.873,  Adjusted R-squared: 0.8716 
#F-statistic: 645.9 on 1 and 94 DF,  p-value: < 2.2e-16 

# Calcul direct
SCR0=sum(  (M0$fitted-perf$delai)^2 ) #7075830
SCRg=sum(  (Mg$fitted-perf$delai)^2 ) # 53920.94
((SCR0-SCRg)/(8-2))/( SCRg/(n-8) ) # F=1909.981
qf(0.95,6,n-8) #2.203439  donc F>qf on rejette H_0, on rejette l'hypothèse d'égalité des droites de regression

anova(M0,Mg) 
# Model 1: delai ~ invdebit
# Model 2: delai ~ systeme * invdebit
# Res.Df     RSS Df Sum of Sq    F    Pr(>F)    
# 1     94 7075830                                
# 2     88   53921  6   7021909 1910 < 2.2e-16 ***
#on rejette (H_0) donc on garde le plus gros mod??le

M2=lm(delai~1+systeme:invdebit,data=perf);summary(M2)
anova(M2,Mg)
# Model 1: delai ~ 1 + systeme:invdebit
# Model 2: delai ~ systeme * invdebit
# Res.Df   RSS Df Sum of Sq      F   Pr(>F)    
# 1     91 68827                                 
# 2     88 53921  3     14906 8.1088 7.91e-05 ***
#on garde Mg


M3=lm(delai~systeme+invdebit,data=perf);summary(M3)
anova(M3,Mg)
# Model 1: delai ~ systeme + invdebit
# Model 2: delai ~ systeme * invdebit
# Res.Df     RSS Df Sum of Sq    F    Pr(>F)    
# 1     91 2636600                                
# 2     88   53921  3   2582679 1405 < 2.2e-16 ***
#on garde Mg

#M4
perf$systeme14=perf$systeme
perf$systeme14[perf$systeme=="S4"]="S1" #on change tous les levels "S4" en "S1"

#systems=c("S1","S2","S3","S4")

#perf$S1S4<-ifelse(perf$systeme=="S1" | perf$systeme=="S4","S1-S4",systems[perf$systeme])
#perf$S2S3<-ifelse(perf$systeme=="S2" | perf$systeme=="S3","S2-S3","S1-S4")


M4= lm(delai~systeme14*invdebit,data=perf);summary(M4)
#                        Estimate Std. Error t value Pr(>|t|)    
#(Intercept)              -33.574      5.539  -6.062 3.10e-08 ***
#systemeS2                 37.218      9.594   3.879 0.000199 ***
#systemeS3                 40.452      9.594   4.217 5.89e-05 ***
#perf$invdebit           5022.984     31.799 157.962  < 2e-16 ***
#systemeS2:perf$invdebit 1903.047     55.077  34.552  < 2e-16 ***
#systemeS3:perf$invdebit 3515.932     55.077  63.837  < 2e-16 ***
#F-statistic: 1.841e+04 on 5 and 90 DF,  p-value: < 2.2e-16 
anova(M4,Mg) # pval=0.68
#on ne rejette pas (H_0) on garde M4


#M5
perf$ord=as.factor(perf$systeme)
levels(perf$ord)=c("1","23","23","1")
M5=lm(delai~ ord+systeme14:invdebit,data=perf);summary(M5)
#M5=lm(delai~ ord+invdebit+systeme14:invdebit,data=perf);summary(M5)
# Estimate Std. Error t value Pr(>|t|)    
# (Intercept)           -33.574      5.511  -6.092 2.63e-08 ***
#   ord23                  38.835      7.794   4.983 2.97e-06 ***
#   systeme14S1:invdebit 5022.984     31.639 158.761  < 2e-16 ***
#   systeme14S2:invdebit 6918.900     37.574 184.141  < 2e-16 ***
#   systeme14S3:invdebit 8546.046     37.574 227.447  < 2e-16 ***
# Residual standard error: 24.46 on 91 degrees of freedom
# Multiple R-squared: 0.999,  Adjusted R-squared: 0.999 
# F-statistic: 2.325e+04 on 4 and 91 DF,  p-value: < 2.2e-16 
anova(M5,Mg) # pval=0.83
#on ne rejette pas M5

anova(M5, M4, Mg)
# Model 1: delai ~ ord + systeme14:invdebit
# Model 2: delai ~ systeme14 * invdebit
# Model 3: delai ~ systeme * invdebit
# Res.Df   RSS Df Sum of Sq      F Pr(>F)
# 1     91 54441                           
# 2     90 54390  1     51.54 0.0841 0.7725 
# 3     88 53921  2    468.75 0.3825 0.6833 
#on garde le plus petit modèle : M5
anova(M5,M4) #on compare toujours le plus petit modèle au plus gros
#on garde le modèle M5

plot(perf$invdebit,perf$delai,col=as.numeric(as.factor(perf$systeme14)),pch=as.numeric(as.factor(perf$systeme)),
     main="temps d'alarme modèle M5",
     xlab="inverse du débit",ylab="délai avant l'alarme")
legend("topleft",levels(as.factor(perf$systeme)),pch=1:4,col=c(1:3,1))
co=M5$coeff
abline( co[1],co[3],col=1) #S1 et S4
abline( co[1]+co[2],co[4],col=2) #S2
abline( co[1]+co[2],co[5],col=3) #S3

library(MASS)
plot(M5$fitted,studres(M5),main="résidus studentisés modèle 3 droites", col=as.numeric(as.factor(perf$systeme)))
abline(h=-2); abline(h=2)

qqnorm(studres(M5),main="graphe quantile-quantile")
abline(0,1)
shapiro.test(studres(M5))

###
### 2.7 Intervalle de confiance
###

## IC de la différence de temps d'alarme quand le débit est de 0.2
# les ordonnées à l'origine étant les mêmes:
M5=lm(delai~ ord+invdebit+systeme14:invdebit,data=perf) # 5 paramètres estimés
V=vcov(M5)[4:5,4:5] #X^TX est une matrice 5*5 et on récupère donc la matrice de variance-covariance associée aux paramètres b_2 et b_3
co=coef(M5)[4:5]
L=cbind(-1,1)*0.2
L%*%co # estimation ponctuelle (\hat{Y}_S3-\hat{Y}_S2=(\hat{b}_3-\hat{b}_2)*invdebit)
c(min=L%*%co-qt(0.975,M5$df.residual)*  sqrt(L%*%V%*%t(L)), 
  max= L%*%co+qt(0.975,M5$df.residual)* sqrt(L%*%V%*%t(L)) ) # 309.3251 341.5332

# plot(perf$invdebit,perf$delai,col=as.numeric(as.factor(perf$systeme14)),pch=as.numeric(as.factor(perf$systeme)),
#      main="temps d'alarme modèle M5",
#      xlab="inverse du débit",ylab="délai avant l'alarme")
# legend("topleft",levels(as.factor(perf$systeme)),pch=1:4,col=c(1:3,1))
# co=M5$coeff
# abline( co[1],co[3],col=1) #S1 et S4
# abline( co[1]+co[2],co[3]+co[4],col=2) #S2
# abline( co[1]+co[2],co[3]+co[5],col=3) #S3
# 


