################################
#### Elements de corrigé du TP1
###############################

help("mean")    # charge la doc de la commande 
?mean           # idem
??mean          # commandes dont le nom ou la vignette contiennent la chaîne
apropos("mean") # commandes dont le nom contient la chaîne

#########################################################
#### 1. Notions de base
#########################################################

# 1.1 Assigner une valeur -------------------------------
x <- 20
x = 20   # idem
x
print(x) # autre commande

a=((1+sqrt(5))/2)^2 # le nombre d'or au carré
a

objects()
ls()     # autre commande
rm(x)    # suppression de l'objet x

rm(list=objects()) # suppression de tous les objets en mémoire


 ## 1.2 Répertoire de travail ----------------------------

getwd() # indique le répertoire de travail en cours

# définit le répertoire MonRepertoire à mettre en cours: à mettre en entête de fichier
setwd("/Users/sarahlemler/Documents/Enseignements/EnseignementCentrale/StatAvancees2A/StatAvancées2024/TP/TP1")

## 1-3 Fichier de script---------------------------------

source("monTP.R")

########################################################
#### 2. Quelques objets R
########################################################

#2.1 Vecteurs -------------------------------------------

c(3,9,5)
c(1,c(2,3,4),5)
2:12
5:-3
x = c(4,5,6); y = c(2,-2,5)
x + y; -x; x > 5
min(x); sin(x); sort(y); length(x)
z = c("I","love","maths")

## ------------------------------------------------------
x = c(5,6,7,2,3,4)
x[2]
x[c(1,3,5)] # Indices positifs
x[c(-3,-4)] # Indice négatif, exclut le 3ème élément de x
x[c(T,T,F,F,T,T)] # Indice valeurs logiques
x[x > 5]

## ------------------------------------------------------
v1=c(-1,3.2,-2,8)
v1  # OK
V1  # erreur, R est sensible à la casse
v2=-2:6
v3=seq(0.05,0.2,0.05)
v4=rep(1,10)
v5=c("OUI","NON")

sort(v1)

# opération composante par composante et recyclage
v6=2*v2-3
v3+v2  # warning, recyclage des coordonnées
log(v3)
v5+1 # erreur puisque v5 est de mode character

v5[2]
length(v6)
v7=v6[length(v6)-(2:0)]
v7=tail(v6,3) #plus simple !
sum(v6)

## -------------------------------------------------------
nbc = c(4138,7077,11176,6474,3735,2365,1573)
pctb= c(1.1,6.6,26.3,64.7,88.7,98,99.9)
sum(nbc*pctb)/sum(nbc) ## 40,62%
weighted.mean(pctb,nbc) # idem

# 2.2 Structure de données -------------------------------

df= data.frame(nbc,pctb,
               taille=c("<100","100-199","200-499","500-999",
                        "1000-1999","2000-4999","plus de 5000"))
print(df)   # comparer avec View(df), clic dans l'onglet environnement

dim(df) #  7 3
head(df)
names(df)
str(df)
summary(df)

df= data.frame(nbc,pctb,
               taille=c("<100","100-199","200-499","500-999",
                        "1000-1999","2000-4999","plus de 5000"),
               row.names=3) # la colonne 3 donne le nom des observations
dim(df)          #  7 2
nrow(df)         # nombre de lignes (d'individus)
ncol(df)
names(df)        # les noms des variables

head(df)
str(df)          # head(df) mais sous un autre format

df$nbc
df$pctb

summary(df)      # qqs résumés numériques pour chaque variable
mean(df$pctb)    # moyenne
quantile(df$pctb)# quartile

df$pctb    
class(df$pctb)   # vecteur

df["pctb"]  
class(df["pctb"])# data.frame à une seule variable

max(df$pctb)     # valeur max de la variable pctb
df[1:4,2]        # valeur de la deuxième variable sur les lignes 1 à 4 


#rm(pctb)
#rm(nbc)
attach(df)       # accès direct aux colonnes, mais attention !! certaines variables souvent utilisées 
detach(df)       # peuvent être écrasées par les variables de df, par exemple si la variable est x


## -------------------------------------------------------
library(MASS)    # charger le package
?genotype        # documentation du jeu de données
summary(genotype)# le résumé numérique dépend du type de variable
str(genotype)

# quali: table
table(genotype$Mother)

# quanti: mean, median, quantile, min, max
quantile(genotype$Wt,(1:3)/4)
var(genotype$Wt) # variance non biaisée <> variance empirique
sum((genotype$Wt-mean(genotype$Wt))^2)/(length(genotype$Wt)-1)

# observations des portées de génotype I ou dont la mère est de génotype A
genotype[ genotype$Litter=="I" | genotype$Mother=="A" ,]
# génotype de la mère est A ET celui de la portée est B
genotype[ genotype$Litter=="B" & genotype$Mother=="A" ,] 

?tapply         # exécute une fonction sur chaque ligne (1) ou colonne(2)
# moyenne de poids en fonction du génotype de la mère 
tapply(genotype$Wt,genotype$Mother,mean)
# moyenne de poids en fonction du génotype de la mère et de la portée 
tapply(genotype$Wt,                                         # variable
       list(mother=genotype$Mother,litter=genotype$Litter), # groupes
       mean)                                                # fonction
# moyenne générale
mean(genotype$Wt)

########################################################
#### 3. Graphiques
########################################################
demo(graphics)
## --- 1
plot(genotype$Litter)               # diagramme en barres des fréquences (nombre d'occurences)

Litter.table=table(genotype$Litter) #  table de comptage

# découper l'écran en deux partie, définir les marges externes
par(mfrow=c(1,2),oma=c(0,0,3,0))    
barplot(Litter.table,
        main="diagramme en barres", 
        col=rainbow(4))             # choisir des couleurs dans une palette

pie(Litter.table,col=rainbow(4),main="camembert")
title(main="Répartition des génotypes des portées",
      outer=TRUE)

## --- 2 et 3
par(mfrow=c(1,1),oma=c(0,0,0,0))    # pour revenir à un seul graphique
barplot(Litter.table/sum(Litter.table),  # en proportion 
        main="diagramme en barres",col=rainbow(4),
        density=10,                 # lignes hachurées
        horiz=TRUE)                 # barres horizontales

## --- 4
poids=genotype$Wt
plot(poids) # les valeurs du poids en fonction de l'index de l'observation. 
hist(poids) # histogramme en fréquence (nombre d'occurrences)
paste("moy",round(mean(poids),2) ) # concatène une chaîne de caractère et un numeric

## --- 5
attach(genotype)
m=mean(Wt) ; s=sd(Wt)
hist(poids,prob=T,  # en proportion
     col="grey",    # couleur de remplissage
     ylim=c(0,0.05),xlim=c(30,80),  # étendue des axes
     main=paste("moy= ",round(m,2),"sd= ",round(s,2) ))  #titre parametre
curve(dnorm(x,m,s),from=30, to=80,add=TRUE,col=2,n=300)

# --- 6 boîte à moustaches
boxplot(poids,horizontal=TRUE)
points(mean(poids),1,pch=8,col="red")
mean(poids)
median(poids)

#######################################################
#### 4. Import et export de données
#######################################################

## fichier texte
write.table(df,"boulangeries.txt",row.names=T,col.names=T,sep=";",quote=FALSE)

# ajouter une premiere ligne dans le fichier, sauvegarder et relire
df2=read.table("boulangeries.txt",sep=";",
               header=TRUE,  # le nom des variables est a la ligne precedant la premiere 
               skip=1)        # observation pour sauter la premiere ligne
df2=read.table("boulangeries.txt",sep=";",
               header=TRUE)   # le nom des variables est a la ligne precedant la premiere 

## fichier binaire
save(df,file="boulangeries.RData")
rm(df)
load("boulangeries.RData")

#######################################################
#### 5 Analyse statistique
#######################################################

df=read.table("mineral.data",dec=",",header=TRUE)
dim(df)#[1] #10  1
n=dim(df)[1]
n=nrow(df)
summary(df);
s=sd(df$nitrate)
m=mean(df$nitrate)

boxplot(df$nitrate)
points(1,m,pch=8,col="red")

out=hist(df$nitrate,freq=F
         ,main="nitrate",xlab="taux de nitrate")
curve(dnorm(x,mean=m,sd=s),from=min(out$breaks), to=max(out$breaks),add=TRUE,col="purple")
qqnorm((df$nitrate-m)/s)
abline(0,1)


ks.test(scale(df$nitrate),pnorm) # expliquer le warning...
ks.test(df$nitrate,pnorm,mean=m,sd=s)  # idem
shapiro.test(df$nitrate)
# on conserve l'hypothèse nulle de normalité, mais avec un risque de seconde espèce inconnu

alpha=0.05
q=qt(1-alpha/2,n-1)
c(min=m-q*s/sqrt(n),max=m+q*s/sqrt(n))
t.test(df$nitrate)$conf.int # 3.520429 3.617571

alpha=0.1
q=qt(1-alpha/2,n-1)
c(min=m-q*s/sqrt(n),max=m+q*s/sqrt(n))
t.test(df$nitrate,conf.level=1-alpha)$conf.int # 3.529641 3.608359

t.test(df$nitrate, alternative="greater", mu=3.53) 
# modèle Yi~N(mu, sigma^2) iid
# H0: eau normale mu=3.53 contre H1: eau anormalement nitratée mu>3.53
# sous H0 mu=3.53 la statistique de Student T~sim T(n-1)
# région de rejet de niveau 5%: R={ T>qt(1-alpha,n-1) }
tobs= sqrt(n)*(m-3.53)/s   # 1.816411
qt(.95,n-1)                # 1.833113
# tobs<qt(.95,n-1) donc on conserve H0
# autre méthode: pvalue>0.05, idem on conserve H0
# autre méthode: 3.53 appartient à l'IC observé, idem on conserve H0
# Les données ne sont pas significatives pour dire que la concentration en nitrates est supérieure 
# au seuil : on accepte que le fournisseur n'ait pas sous-estimé la concentration, mais avec 
# un rique de seconde espèce inconnu)

t.test(df$nitrate, alternative="greater", mu=3.53,conf.level=1-alpha)$conf.int
# au niveau 10% on rejette H0 
# soit par la pvalue, soit parce que 3.53 n'appartient pas à l'IC observé
# Le fournisseur a sous-estimé, on prend cette décision avec un risque de première espèce 
# alpha=10%


######################################################
######### 6. Matrices 
######################################################

#matrix(vec,nrow=4,ncol=3)

matrix(c(4,3,-1,10,1,3),nrow=2,ncol=3,byrow=T)

A=rbind(c(4,-1,1),c(3,10,3))
B=cbind(2:4,4:2)
A[,2]
B[3,2]

A*B            #erreur, operation coeff par coeff
A*A
A[,1:2]*B[2:3,]# OK , mais operation coeff par coeff
A%*%B          # multiplication de matrice (operation math)

