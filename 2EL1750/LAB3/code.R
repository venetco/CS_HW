rm(list=objects()); graphics.off()

######### Estimation par projection #############

n=1000 #taille de l'échantillon
X<-4+5*rnorm(n,0,1) #simulation du modèle N(4,25)
#X<-rnorm(n,4,5)

# Le domaine d'estimation et la vraie fonction
aX=min(X)
bX=max(X)
Xplot=seq(aX,bX,0.1)
fvraie=exp(-(Xplot-4)^2/50)/(sqrt(2*pi)*5)
#fvraie=dnorm(Xplot,4,5)
plot(Xplot,fvraie,type='l')

# Base trigonométrique : transformation pour se ramener à l'intervalle [0,1] 
U<-(X-aX)/(bX-aX) 
XXplot<-(Xplot-aX)/(bX-aX)
a1f<-1/sqrt(bX-aX)
a2f<-sqrt(2)*mean(cos(2*pi*U))/sqrt(bX-aX)
a3f<-sqrt(2)*mean(sin(2*pi*U))/sqrt(bX-aX)
a4f<-sqrt(2)*mean(cos(4*pi*U))/sqrt(bX-aX)
a5f<-sqrt(2)*mean(sin(4*pi*U))/sqrt(bX-aX)

estf<-(a1f+sqrt(2)*a2f*cos(2*pi*XXplot)+sqrt(2)*a3f*sin(2*pi*XXplot))/sqrt(bX-aX) #D=3

estfbis<-estf+sqrt(2)*(a4f*cos(4*pi*XXplot)+a5f*sin(4*pi*XXplot))/sqrt(bX-aX)  #D=5
#lines(Xplot,estfbis)

# Base d'histogrammes D=10
D=10
hataf<-rep(0,D)
for (j in 1:10){
  T=((U>=(j-1)/D)&(U<j/D))
  hataf[j]<-sqrt(D/(bX-aX))*mean(T)
}
fhisto<-rep(0,length(Xplot))
for (j in 1:D){
  TT<-((Xplot>=aX+(j-1)*(bX-aX)/D)&(Xplot<aX+j*(bX-aX)/D))
  fhisto<-fhisto+hataf[j]*TT
}
fhisto<-fhisto*sqrt(D/(bX-aX))

plot(Xplot,fvraie,type="l",las=1,col='red')
lines(Xplot,estf,col="blue")
lines(Xplot,estfbis,col="green")
lines(Xplot,fhisto,col="cyan")
legend("topright",c("Vraie","Trigo D=3","Trigo D=5","Histo D=10"), 
       col=c("red","blue","green","cyan"),lty=1,bty='n')
# l'estimée en base trigo est biaisée pour D=3 qui est une dimension trop petite, 
# mais presque parfaite pour 
# D=5. L'histo donne dans ce cas une excellente idée de la courbe que l'on veut 
# reconstruire, mais de manière plus sommaire 

# Sélection de modèles
rm(list=ls())
n=1000 #taille de l'échantillon
X<-rnorm(n,4,5) #simumation du modèle N(4,25)

aX=min(X)
bX=max(X)
Xplot=seq(aX,bX,0.1)
fvraie=exp(-(Xplot-4)^2/50)/(sqrt(2*pi)*5)
plot(Xplot,fvraie,type='l')
U<-(X-aX)/(bX-aX) 
XXplot<-(Xplot-aX)/(bX-aX)


# Base trigonométrique : cas général

d<-floor(sqrt(n)) # dimension D=2d+1<= 2*sqrt(n)+1 arbitraire
af<-rep(0,2*d+1)
gamma<-rep(0,d+1)
pen<-rep(0,d+1)
estf<-matrix(0,length(Xplot),d+1)
kappa=0.1

# Calcul des contrastes -sum(hata_j^2)_j=1^D et des pénalités Kappa*D/n
af[1]<-1/sqrt(bX-aX)
estf[,1]<-af[1]*rep(1,length(Xplot))/sqrt(bX-aX)
gamma[1] = -(af[1]^2)
pen[1]<-kappa/n


for (j in 1:d){
  af[2*j]<-sqrt(2)*mean(cos(2*j*pi*U))/sqrt(bX-aX)
  af[2*j+1]<-sqrt(2)*mean(sin(2*j*pi*U))/sqrt(bX-aX)
  estf[,j+1]<-estf[,j]+sqrt(2)*(af[2*j]*cos(2*pi*j*XXplot)
                                +af[2*j+1]*sin(2*pi*j*XXplot))/sqrt(bX-aX)
  gamma[j+1]<-gamma[j]-(af[2*j])^2-(af[2*j+1])^2
  pen[j+1]<-kappa*(2*j+1)/n
}

# sélection du modèle 
hatd<-which(gamma+pen==min(gamma+pen))
estimfinal<-estf[,hatd]

# représentation graphique de l'estimateur adaptatif
par(mfrow=c(1,1))
plot(Xplot,fvraie,type="l",col="red",las=1)
lines(Xplot,estimfinal,col="blue",lty=2)
# sur le 1er graphe on voit que la dimension sélectionnée est pertinente et 
# que l'algorithme fournit un bon estimateur

plot(Xplot,fvraie,type="l",col="red",las=1,ylim=c(0,max(estf)))
for (j in 1:d){
lines(Xplot,estf[,j],col='blue',lty=2)
}
# sur le 2ème graphe, on voit l'ensemble des estimateurs selon la dimension choisie. 
#On va des estimations très biaisées aux estimations avec trop de variances 
# (fortes oscillations)


###################################################################################
######## Estimateur à noyau

# Estimateur à fenêtre fixée 
set.seed(5)
n=1000
X=rnorm(n,0,1)

# Calcul d'un estimateur à noyau avec un noyau gaussien et d'Epanechnikov
a=min(X)
b=max(X)
Xplot=seq(a,b,0.1)
fvraie=rep(0,length(Xplot))
fvraie=exp(-Xplot^2/2)/sqrt(2*pi)

h=0.1 #0.1 et 0.3 #fenêtre fixée 
fest<-rep(0,length(Xplot))
fest2<-rep(0,length(Xplot))
Gaus<-matrix(0,length(Xplot),n)
EPA<-matrix(0,length(Xplot),n)

for (i in 1:length(Xplot)){
  for (j in 1:n){
    U=(Xplot[i]-X[j])/h
    Gaus[i,j]<-exp(-U^2/2)/(sqrt(2*pi)*h)
    T<-(abs((Xplot[i]-X[j])/h)<=1)
    EPA[i,j]<-(3/4)*(1-U^2)*T/h
  }
}

fest<-apply(Gaus,1,mean)
fest2<-apply(EPA,1,mean)

#par(mfrow=c(2,2))

plot(Xplot,fvraie,type='l',las=1,col='red')
lines(Xplot,fest,col="blue",lty=2)
lines(Xplot,fest2,col="green",lty=4)
legend("topleft",c("vraie","estimée, Gaussien","estimée, Epanechnikov"),
       col=c("red","blue","green"),lty=1,bty="n")

# le choix du noyau et de la fenêtre ont tous les deux une certaine importance dans 
# la qualité de la recontruction. La "bonne valeur" de h n'est pas la même selon les 
# noyaux mais une fois cette valeur trouvée la qualité de la reconstruction dépend 
# peu du noyau choisi. Il est donc important de rendre le choix de h automatique 
#quelle que soit la fonction noyau choisie. 


# Sélection de la fenêtre par validation croisée
K=50 
ab<-seq(a,b,length.out=K)
fvraie=exp(-ab^2/2)/sqrt(2*pi)


# Calcul du critère hatJ(h)
M=40
estimf<-matrix(0,M,K)
h<-rep(0,M)

# 1ère partie du critère : hatf^2
for (k in 1:M){
  h[k]<-k/M
  #Noyau d'Epanechnikov
  Tt<-(abs(((matrix(X,n,K,byrow=F)-t(matrix(ab,K,n,byrow=F)))/h[k]))<=1) 
  # remplissage de la matrice par colonnes
  estimf[k,]<-apply((3/4)*(1-((matrix(X,n,K,byrow=F)
                               -t(matrix(ab,K,n,byrow=F)))/h[k])^2)*Tt,2,mean)/h[k]
  #estimf[k,]<-apply(exp(-(matrix(X,n,K,byrow=F)
  #                        -t(matrix(ab,K,n,byrow=F)))^2/2),2,mean)/(sqrt(2*pi)*h[k])
  }


# 2ème partie du critère : sum_i!=j
Mat<-array(0, dim=c(n,n,K))
R<-diag(1,n,n)
h<-rep(0,M)
for (k in 1:M){
  h[k]<-k/M
  for (i in 1:n){
    for (j in 1:n){
      aa<-(abs((X[i]-X[j])/h[k])<=1)
      Mat[i,j,k]<-(3/4)*(1-((X[i]-X[j])/h[k])^2)*aa/h[k]-(3/4)*R[i,j]/h[k]
      #Mat[i,j,k]<-exp(-(X[i]-X[j])^2/2)/(sqrt(2*pi)*h[k])
    }
  }
}

Crit<-rep(0,M)
for (k in 1:M){
  Crit[k]<-sum(estimf[k,]^2)*(b-a)/K-2*sum(apply(Mat[,,k],1,sum))/(n*(n-1))
}

# Sélection de la fenêtre
estimfinal<-rep(0,K)
hath<-which.min(Crit)
#hath<-which(Crit==min(Crit))
estimfinal<-estimf[hath,]

par(mfrow=c(1,2))
plot(ab,fvraie,type="l",las=1,col="red")
lines(ab,estimfinal,col="blue",lty=2)

plot(ab,fvraie,type="l",las=1,col="red",ylim=c(0,max(estimf)))
for (k in 1:M){
  lines(ab,estimf[k,],col="blue",lty=2)  
}

x# Essayer avec d'autres lois

########################################################################
######## Estimateur d'une fonction de régression
rm(list=objects()); graphics.off()
# Estimation sans sélection de modèle
n<-1000

#simulation du modèle
eps<-0.5*rnorm(n) # epsilon~N(0,0.5)
X<-rnorm(n) # X~N(0,1) # observations
mX<- X^4 # la fonction non linéaire à estimer
# mX=aX+b
# mX=exp(X)
# mX=X^2*exp(-3*abs(X))

Y<-mX+eps

# les vraies fonctions
aX<-min(X)
bX<-max(X)
Xplot<-seq(aX,bX,length.out=100)

mVraie<-Xplot^4
# mVraie=aXplot+b
# mVraie=exp(Xplot)
# mVraie=Xplot^2*exp(-3*abs(Xplot))

# estimation en polynômes trigonométriques 
U<-(X-aX)/(bX-aX) #pour se ramener à [0,1] (observations)
XXplot<-(Xplot-aX)/(bX-aX) #(points en lesquels on va calculer l'estimateur)
d<-10

phi<-matrix(0,length(U),2*d+1) # de taille n*D
phi[,1]<-1/sqrt(bX-aX)*rep(1,length(U)) 
phiplot<-matrix(0,length(XXplot),2*d+1) # de taille length(XXplot)*D
phiplot[,1]<-1/sqrt(bX-aX)*rep(1,length(XXplot))


for (j in 1:d){
  phi[,2*j]<-sqrt(2)*cos(2*j*pi*U)/sqrt(bX-aX)
  phi[,2*j+1]<-sqrt(2)*sin(2*j*pi*U)/sqrt(bX-aX)
  phiplot[,2*j]<-sqrt(2)*cos(2*j*pi*XXplot)/sqrt(bX-aX)
  phiplot[,2*j+1]<-sqrt(2)*sin(2*j*pi*XXplot)/sqrt(bX-aX)
}

library(MASS) #pour la fonction ginv (solve ne marche pas ici)
hataf<-ginv(t(phi)%*%phi/n)%*%t(phi)%*%Y/n 
# hat_a_D<-G_D^{-1}Phi_D^TY/n=(1/n^2)Phi_DPhi_D^TPhiDY
estmX<-phiplot%*%hataf # hat_f<-t(Phiplot_D)%*%hat_a_D

# Représentation graphique

plot(Xplot,mVraie,col="red",las=1,type="l")
lines(Xplot,estmX,col="blue")

# Moindres carrés adaptatifs (sélection du modèle)


rm(list=objects()); graphics.off()
# Estimation sans sélection de modèle
n<-1000

#simulation du modèle
eps<-0.5*rnorm(n) # epsilon~N(0,sqrt(0.5))
X<-rnorm(n) # X~N(0,1) # observations
mX<- X^2 # la fonction non linéaire à estimer
# mX=aX+b
#mX=exp(X)
# mX=X^2*exp(-3*abs(X))

Y<-mX+eps

# les vraies fonctions
aX<-min(X)
bX<-max(X)
Xplot<-seq(aX,bX,length.out=100)

mVraie<-Xplot^2
# mVraie=aXplot+b
# mVraie=exp(Xplot)
# mVraie=Xplot^2*exp(-3*abs(Xplot))

# estimation en polynômes trigonométriques 
U<-(X-aX)/(bX-aX) #pour se ramener à [0,1] (observations)
XXplot<-(Xplot-aX)/(bX-aX) #(points en lesquels on va calculer l'estimateur)

dmax<-floor(sqrt(n))

phi<-matrix(0,length(U),2*dmax+1) # de taille n*D
phi[,1]<-1/sqrt(bX-aX)*rep(1,length(U)) 
phiplot<-matrix(0,length(XXplot),2*dmax+1) # de taille length(XXplot)*D
phiplot[,1]<-1/sqrt(bX-aX)*rep(1,length(XXplot))


for (j in 1:dmax){
  phi[,2*j]<-sqrt(2)*cos(2*j*pi*U)/sqrt(bX-aX)
  phi[,2*j+1]<-sqrt(2)*sin(2*j*pi*U)/sqrt(bX-aX)
  phiplot[,2*j]<-sqrt(2)*cos(2*j*pi*XXplot)/sqrt(bX-aX)
  phiplot[,2*j+1]<-sqrt(2)*sin(2*j*pi*XXplot)/sqrt(bX-aX)
}

gammapen<-rep(0,dmax)
for (k in 1:dmax){
  hataf<-ginv(t(phi[,1:(2*k+1)])%*%phi[,1:(2*k+1)]/n)%*%t(phi[,1:(2*k+1)])%*%Y/n 
  # hat_a_D<-G_D^{-1}Phi_D^TY/n=(1/n^2)Phi_DPhi_D^TPhiDY
  estmX<-phi[,1:(2*k+1)]%*%hataf 
  # hat_f<-t(Phi_D)%*%hat_a_D calculé en les observations
  gammapen[k]<--sum(estmX^2)+(5/2)*0.5*(2*k+1)
}


dopt<-which(gammapen==min(gammapen))
hatafD<-ginv(t(phi[,1:(2*dopt+1)])%*%phi[,1:(2*dopt+1)]/n)%*%t(phi[,1:(2*dopt+1)])%*%Y/n
estmX<-phiplot[,1:(2*dopt+1)]%*%hatafD 

# Représentation graphique
plot(Xplot,mVraie,col="red",las=1,type="l")
lines(Xplot,estmX,col="blue")

