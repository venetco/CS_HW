#
# les commandes de l'énoncé
#
help("mean")
?mean
??mean
apropos("mean")

x <- 20
x = 20 # autre commande
x
print(x) # autre commande

objects()
ls() # autre commande
rm(x) # suppression de l'objet x

rm(list=objects()) # suppression de tous les objets en mémoire

getwd() # indique le répertoire de travail en cours
## setwd("MonRepertoire") # définit le répertoire en cours

## -------------------------------------------------------------
c(3,9,5)
c(1,c(2,3,4),5)
2:12
5:-3

x = c(4,5,6); y = c(2,-2,5)
x + y; -x; x > 5
min(x); sin(x); sort(x);  length(x)
min(x); sin(x); sort(x); length(x)
z = c("I","love","maths")

## -------------------------------------------------------------
x = c(5,6,7,2,3,4)
x[c(1,3,5)] # Indices positifs
x[-3] # Indice négatif, exclut le 3ème élément de x
x[c(T,T,F,F,T,T)] # Indice valeurs logiques
x[x > 5]

## -----------------à compléter----------------------------------------
v1=

  
nbc = c(4138,7077,11176,6474,3735,2365,1573)
pctb = c(1.1,6.6,26.3,64.7,88.7,98.0,99.9)
  
## ------------------------------------------------------------------------
df= data.frame(n=nbc,pctb,
               taille=c("<100","100 à 199","200 à 499","500 à 999",
                        "1000 à 1999","2000 à 4999","plus de 5000"),
               row.names=3) # rôle de ce paramètre ?
print(df)
dim(df)
nrow(df)
names(df)

head(df)
str(df)
summary(df)

df$pctb
df["pctb"] # différence avec le précédent ?
max(df$pctb)
df[1:4,2]

attach(df) # accès direct aux colonnes, mais attention !!
detach(df) 

library(MASS)
?genotype
genotype[ genotype$Litter=="I" | genotype$Mother=="A" ,]
?tapply
tapply(genotype$Wt,genotype$Mother,mean)


## ------------------------------------------------------------------------

plot(genotype$Litter)

Litter.table=table(genotype$Litter)

par(mfrow=c(1,2),oma=c(0,0,3,0))
barplot(Litter.table,main="diagramme en barres", col=rainbow(4))

pie(Litter.table,col=rainbow(4),main="camembert")
title(main="Répartition des génotypes des portées", outer=TRUE)

## 
par(mfrow=c(1,1))
poids=genotype$Wt
m=mean(poids) ; s=sd(poids)
plot(poids) 
hist(poids, prob=T, ylim=c(0,0.05), xlim=c(30,80), main=paste("moy= ",round(m,2),"sd= ",round(s,2)))
paste("moy=", round(mean(poids),2))


## ------------------------------------------------------------------------
write.table(df,"boulangeries.txt",row.names=FALSE,sep=";",quote=FALSE)
df2=read.table("boulangeries.txt",sep=";",header=TRUE,skip=1)
save(df,file="boulangeries.RData")
rm(df)
load("boulangeries.RData")


## Analyse statistique à compléter

df=read.table("mineral.data",dec=",", header=TRUE)
df
summary(df)
hist(df$nitrate, prob=T)
curve(dnorm(x,df$nitrate,mean=mean(df$nitrate), sd = sd(df$nitrate)), add=TRUE)
qqnorm((df$nitrate-mean(df$nitrate))/sd(df$nitrate))
abline(0,1)
ks.test(scale(df$nitrate),pnorm)
ks.test(df$nitrate,pnorm,mean=mean(df$nitrate),sd=sd(df$nitrate))
shapiro.test(df$nitrate)
?ks.test



## ------------------------------------------------------------------------
n=4 # nombre de lignes
p=3 # nombre de colonnes
matrix(vec,nrow=n,ncol=p)
