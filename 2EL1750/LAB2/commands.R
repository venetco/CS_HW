## ------------------------------------------------------------------------
setwd("Mon répertoire") # à personnaliser
rm(list=objects())
graphics.off()

###############################
#### 1 Régression linéaire
###############################
#Récupérer les données sur Edunao
Prostate<-read.table("Prostate.txt",sep=";",header=T,dec=".")

## ------------------------------------------------------------------------
head(df)
dim(df)
str(df)

## ------------------------------------------------------------------------
summary(df)
pairs(df)
cor(df)

library(corrplot)
corrplot(cor(df))

apply(Prostate,2,mean)
apply(Prostate,2,sd)

## ------------------------------------------------------------------------
X=as.matrix(Prostate[,1:8])
X=cbind(intercept=1,X)           # intercept

Y=as.matrix(Prostate$lpsa,ncol=1)
beta.est=solve(t(X)%*%X)%*% t(X)%*%Y

n=length(Y)
p=ncol(X)

sigma.est=sqrt(sum( (X%*%beta.est -Y)^2   )/(n-p)) #   0.7084164 
ddl=n-p #88
V= solve(t(X)%*%X) *sigma.est^2.
stddev=sqrt(diag(V))

T = abs(beta.est/stddev)  # T value

alpha = 0.05 
qt(1-alpha/2,ddl)
#à compléter
pval = 2*pt(-abs(beta.est/stddev),ddl)

X[2,]%*%beta.est
X%*%beta.est

## ------------------------------------------------------------------------
model8=lm(lpsa~.,data=Prostate)
summary(model8)
names(model8)
beta = model8$coef

V = vcov(model8)
# à compléter !

## ------------------------------------------------------------------------
predict(model8)

## ------------------------------------------------------------------------
# Intervalle de confiance à compléter
alpha = 0.05
qt=qt(1-alpha/2,model8$df.residual)
IC=data.frame(min=beta.est-qt*sqrt(diag(V)),max=beta.est+qt*sqrt(diag(V)))

confint(model8,level=0.95)

## ------------------------------------------------------------------------
# SCRH1=  sum(model8$resid^2  )
# SCRH0=  # à compléter

## ------------------------------------------------------------------------
anova(lm(lpsa~1,data=Prostate),model8)

anova(lm(lpsa~lcavol,data=Prostate),model8)

## ------------------------------------------------------------------------
# test de significavité globale (à partir de Wald avec loi de Fisher(p-1,n-p))
# A compléter

lmf=lm(lpsa~lcavol+lweight+svi)
anova(lmf,model8)
library(MASS)
stepAIC(model8)
stepAIC(model8,k=log(n))

## ------------------------------------------------------------------------
# fenetre en 2x2,  marge haute pour titre general
par(mfrow=c(2,2), oma=c(0,0,2,0)) 

# 
plot(lmf$fitted,Prostate$lpsa,main="ajustes/observes")
abline(0,1)

# 
plot(lmf$fitted,lmf$residuals,main="differents residus",ylim=c(-3,3))
abline(h=0,lty=2)

library(MASS)
plot(lmf$fitted,stdres(lmf), col=2,pch=2 ,ylim=c(-3,3),
     main="à compléter")
points(lmf$fitted,studres(lmf),col=3,pch=3) 
abline(h=2); abline(h=-2); abline(h=0,lty=2)
legend("bottomright",c( "stdres", "studres"),col=2:3, pch=2:3,cex=0.5)

# 
qqnorm(studres(lmf),main="à compléter")
qqline(stdres(lmf))

# 
title(main="Validation en régression linéaire multiple", outer=TRUE)

## ------------------------------------------------------------------------
par(mfrow=c(2,2))
plot(lmf)

###############################
#### 2 ANCOVA
###############################
rm(list=objects()); graphics.off()
perf=read.table("perfusion.txt",header=TRUE, row.names=1,skip=1)
head(perf)
str(perf)
dim(perf) # 96 observations
n=nrow(perf)
summary(perf)

## ------------------------------------------------------------------------
table(perf$systeme,perf$debit)
tapply(perf$delai, list(perf$systeme, perf$debit),mean)

## ------------------------------------------------------------------------
library(lattice)
xyplot(delai~debit|systeme,data=perf)

## ------------------------------------------------------------------------
perf$invdebit=1/perf$debit
plot(perf$invdebit,perf$delai,col=c(1:4),
     pch=c(1:4))

## ------------------------------------------------------------------------
plot(perf$invdebit,perf$delai,col=as.numeric(perf$systeme),
     pch=as.numeric(perf$systeme))
# à compléter

## ------------------------------------------------------------------------
Mg=lm(delai~systeme*invdebit,data=perf)
summary(Mg)
anova(Mg)

co=Mg$coeff
abline( co[1],co[5],col=1) 
for (i in 2:4) abline( co[1]+co[i],co[5]+co[4+i],col=i)



## ------------------------------------------------------------------------
attach(perf)
Mgbis=lm(delai~systeme+systeme:invdebit,data=perf)
summary(Mgbis)
anova(Mgbis)

## ------------------------------------------------------------------------
# à compléter


##-------------------------------------------------------------------------
# directement
M0=lm(delai~invdebit)  # à compléter
SCR0=
SCRg=
  
# commande anova
anova(M0,Mg)


## ------------------------------------------------------------------------
M2=lm(delai~systeme:invdebit,data=perf);summary(M2)
anova(M2,Mg)

M3=lm(delai~systeme+invdebit,data=perf);summary(M3)
anova(M3,Mg)

perf$syst=perf$systeme
perf$syst[perf$systeme=="S4"]="S1"

M4= lm(delai~syst*invdebit,data=perf);summary(M4)
anova(M4,Mg)

# à compléter pour M5
perf$ord=as.factor(perf$systeme)
levels(perf$ord)=c("1","23","23","4")
M5=lm(delai~ ord+syst:invdebit, data=perf)

## -------------------------------------------------------------------------
# Validation

## -------------------------------------------------------------------------
# Intervalle de confiance
