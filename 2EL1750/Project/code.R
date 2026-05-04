# Répertoir de travail et nettoyage de l'environnement
setwd("/Users/corentinvenet/Desktop/CS/2A/S8/statistiques avancées/DM")

# Nettoyage de l'environnement
rm(list=objects())
graphics.off()

# Chargement de la base de données
Ozone <- read.table("Ozone.csv",sep=";",header=T,dec=".")

# Convertion des valeurs des variables décimales en format numérique
Ozone$T9 <- as.numeric(gsub(",", ".", Ozone$T9))
Ozone$T12 <- as.numeric(gsub(",", ".", Ozone$T12))
Ozone$T15 <- as.numeric(gsub(",", ".", Ozone$T15))
Ozone$Vx9 <- as.numeric(gsub(",", ".", Ozone$Vx9))
Ozone$Vx12 <- as.numeric(gsub(",", ".", Ozone$Vx12))
Ozone$Vx15 <- as.numeric(gsub(",", ".", Ozone$Vx15))

# Convertion des variables qualitatives (vent et pluie) en facteurs
Ozone$vent <- as.factor(Ozone$vent)
Ozone$pluie <- as.factor(Ozone$pluie)

# Suppression de la colonne obs qui correspond au numéro d'observation et donc à aucune donnée météorologique pouvant influencer la concentration en ozone maximale maxO3
Ozone <- subset(Ozone, select = -obs)

## QUESTION 1 : Analyse descriptive des données

# Caractéristiques de la base de données
dim(Ozone)
head(Ozone)
names(Ozone)
str(Ozone)

# Quelques statistiques sur chaque colonne : analyse univariée
summary(Ozone)

# Analyse bi-variée 
pairs(Ozone)

# Analyse bi-variée des variables quantitatives
Ozoneqqt <- subset(Ozone, select = -pluie)
Ozoneqqt <- subset(Ozoneqqt, select = -vent)
library(corrplot)
corrplot(cor(Ozoneqqt))

## QUESTION 2 : Modèle linéaire

# Modèle linéaire obtenu par la fonction lm de R
model=lm(maxO3~.,data=Ozone)
summary(model)

## QUESTION 3 : fonction stepAIC

library(MASS)
?stepAIC

## QUESTION 4 : modèle choisi par critère BIC

stepAIC(model,direction='both',trace=1,k=log(dim(Ozone)[1]))

# Intervalles de confiance
confint(stepAIC(model,direction='both',trace=1,k=log(dim(Ozone)[1])))  

## QUESTION 5 : Recherche exhaustive avec la fonction regsubsets

library(leaps)
recherche=regsubsets(maxO3~.,method="exhaustive",data=Ozone)

## QUESTION 7 : Graphiques de la fonction regsubsets

# Graphique des critères de sélection de modèles, avec le nom des variables choisies in fine
par(mfrow=c(2,2),oma=c(0,0,3,0)) 
plot(recherche,scale="bic",xlab="Nombre de variables",ylab="BIC",main='BIC')
plot(recherche,scale="Cp",xlab="Nombre de variables",ylab="Cp",main='Cp')
plot(recherche,scale="adjr2",xlab="Nombre de variables",ylab="adjR2",main='adjR2')
plot(recherche,scale="r2",xlab="Nombre de variables",ylab="R2",main='R2')
title(main="Critères de sélection de modèles",outer=TRUE)

# Graphique du nombre de covariables idéal à choisir
par(mfrow=c(2,2),oma=c(0,0,3,0))
plot(summary(recherche)$bic,xlab="Nombre de variables",ylab="BIC",main='BIC')
plot(summary(recherche)$cp,xlab="Nombre de variables",ylab="Cp",main='Cp')
plot(summary(recherche)$rsq,xlab="Nombre de variables",ylab="R2",main='R2')
plot(summary(recherche)$adjr2,xlab="Nombre de variables",ylab="adjR2",main="adjR2")
title(main="Nombre de covariables idéal",outer=TRUE)

## QUESTION 8 : modèle de plus faible BIC

# Valeurs de BIC en fonction du nombre de variables
summary(recherche)$bic

# Modèle de plus faible BIC
modelfinal=lm(maxO3 ~ T12 + Ne9 + Vx9 + maxO3v, data = Ozone)
summary(modelfinal)

# Comparaison des 2 modèles obtenus
anova(modelfinal,model)

## QUESTION 9 : Validation du modèle

par(mfrow=c(2,2), oma=c(0,0,2,0)) 

# Graphique des ajustés/observés
plot(modelfinal$fitted,Ozone$maxO3,main="ajustés/observés")
abline(0,1)

# Graphique des différents résidus
plot(modelfinal$fitted,modelfinal$residuals,main="différents résidus",ylim=c(-3,3))
points(modelfinal$fitted,stdres(modelfinal), col=2,pch=2 )
points(modelfinal$fitted,studres(modelfinal),col=3,pch=3)
abline(h=2)
abline(h=-2)
legend("bottomright",c("resid", "stdres", "studres"),col=1:3, pch=1:3,cex=0.5)

# Graphique quantile/quantile
qqnorm(studres(modelfinal),main="graphe quantile-quantile")
qqline(stdres(modelfinal))

title(main="Validation en regression linéaire multiple", outer=TRUE)

par(mfrow=c(2,2), oma=c(0,0,2,0)) 
plot(modelfinal, caption = list("Residuals vs Fitted", "Normal Q-Q","Cook's distance","Residuals vs Leverage",expression("Residuals vs Leverage")))

## QUESTION 10 : Calcul de l'erreur de prédiction

# Nombre de parties pour la validation croisée fixé
nbre_part <- dim(Ozone)[1] # Par exemple ici on est dans le cas particulier du Leave-one-out

# Création des indices
indices <- split(sample(1:dim(Ozone)[1]), 1:nbre_part)

# Vecteur pour stocker les erreurs de chaque partie
EQMP_valeurs <- numeric(nbre_part)

for (i in 1:nbre_part) {
  # Séparation des données entre apprentissage et test
  appr_indices <- unlist(indices[-i])
  test_indices <- indices[[i]]
  
  appr_data <- Ozone[appr_indices, ]
  test_data <- Ozone[test_indices, ]
  
  # Ajustement du modèle sur les données d'apprentissage
  model <- lm(maxO3 ~ T12 + Ne9 + Vx9 + maxO3v, data = appr_data)
  
  # Prédiction sur les données de test
  predictions <- predict(model, newdata = test_data)
  
  # Calcul de l'erreur quadratique moyenne de prévision (EQMP) pour cette partie
  EQMP_valeurs[i] <- sum((predictions - test_data$maxO3)^2) / length(predictions)
}

# Calcul de l'EQMP global (moyenne des EQMP de chaque partie)
EQMP <- mean(EQMP_valeurs)