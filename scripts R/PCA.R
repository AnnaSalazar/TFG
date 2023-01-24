numeriques <- which(sapply(accident, is.numeric))
dcon <- accident[, numeriques]
sapply(dcon, class)
pc1 <- prcomp(dcon, scale = TRUE)
class(pc1)
attributes(pc1)
print(pc1)

# Quin tant per cent de inèrcia està representada en els subespais?
# Volem saber quantes dimensions son necesaries per representar fins el 80% de la inercia (variabilitat)
pc1$sdev
(inerProj<- pc1$sdev^2)
(totalIner<- sum(inerProj))
(pinerEix<- 100*inerProj/totalIner)

# Inèrcia representada gràficament
fviz_screeplot(pc1, addlabels = TRUE, ylim = c(0, 30),
               barfill ="#1d91c0", barcolor ="#1d91c0",
               ggtheme = theme_minimal())

percInerAccum <- 100*cumsum(pc1$sdev[1:dim(dcon)[2]]^2)/dim(dcon)[2]

# Ens quedem amb les primeres 4 components
nd = 4
print(pc1)
attributes(pc1)
pc1$rotation #components principals
dim(pc1$x)
dim(dcon)

# Dades als nous eixos de les 4 PCA
Psi = pc1$x[,1:nd]
dim(Psi)

iden = row.names(dcon) #Etiquetes dels individus
etiq = names(dcon) #etiquetes de les variables numeriques
ze = rep(0,length(etiq)) # Necessitarem aquest vector després pels gràfics

# Gràfic de projecció d'individus (accidents)
fviz_pca_ind(pc1, geom.ind = "point",
             habillage=accident$HIHAMORTS,
             axes = c(1, 2),
             pointsize = 1.5, title = "Accidents - PCA", legend.title = "HIHAMORTS" )

###################################
## Projecció variables numèriques #
###################################

X <- Phi[, 1] # Primera component
Y <- Phi[, 2] # Segona component

#zooms per poder representar-los be
plot(Psi[,1], Psi[,2], type = "n", xlim = c(min(X, 0),
                                            max(X, 0)), ylim = c(-1,1),
     xlab = "CP1: Nombre de persones involucrades",
     ylab = "CP2: Condicions en què es dona l'accident")
axis(side=1, pos= 0, labels = F)
axis(side=3, pos= 0, labels = F)
axis(side=2, pos= 0, labels = F)
axis(side=4, pos= 0, labels = F)
arrows(ze, ze, X, Y, length = 0.07,col="blue")
text(X,Y,labels=etiq,col="darkblue", cex=0.7)

# Gràfics de com¡ntribució a les components principals
par(mfrow = c(1,2))
fviz_contrib(pc1, choice = "var", axes = 1, caption=NULL)

fviz_contrib(pc1, choice = "var", axes = 2, caption=NULL)


#####################################
## Projecció variables categòriques #
#####################################

(var_categoriques <- which(sapply(accident, is.factor)))

# Totes les variables qualitatives juntes
plot(Psi[,1], Psi[,2], type = "n", xlim = c(-0.4,0.6), ylim = c(-1, 1),
     xlab = "CP1: Nombre de persones involucrades", ylab = "CP2: Condicions en què es dona l'accident")

axis(side = 1, pos = 0, labels = F, col = "cyan")
axis(side = 3, pos = 0, labels = F, col = "cyan")
axis(side = 2, pos = 0, labels = F, col = "cyan")
axis(side = 4, pos = 0, labels = F, col = "cyan")
#nominal qualitative variables
dcat <- c(1:6)

colors <- rainbow(length(var_categoriques))
c <- 1
for(k in var_categoriques){
  seguentColor<-colors[c]
  varcat <- as.factor(accident[,k])
  fdic1 <- tapply(Psi[,1], varcat, mean)
  fdic2 <- tapply(Psi[,2], varcat, mean)
  text(fdic1, fdic2, levels(varcat), col = seguentColor, cex = 1, font = 3)
  c <- c + 1
}
legend("bottomleft",names(var_categoriques)[dcat], pch = 1, col = colors, cex = 0.6)


############### **Variable Dia**
plot(Psi[,1], Psi[,2], type = "n", xlim = c(-0.4, 0.4), ylim = c(-0.4, 0.4),
     xlab = "CP1: Nombre de persones involucrades",
     ylab = "CP2: Condicions en què es dona l'accident")

axis(side = 1, pos = 0, labels = F, col = "lightblue")
axis(side = 3, pos = 0, labels = F, col = "lightblue")
axis(side = 2, pos = 0, labels = F, col = "lightblue")
axis(side = 4, pos = 0, labels = F, col = "lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(1)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)


############### **Variable Localització**
plot(Psi[,1],Psi[,2],type="n",xlim=c(-0.3,0.3), ylim=c(-0.2,0.2),
     xlab = "CP1: Nombre de persones involucrades", ylab = "CP2: Condicions en què es dona l'accident")
axis(side=1, pos= 0, labels = F, col="lightblue")
axis(side=3, pos= 0, labels = F, col="lightblue")
axis(side=2, pos= 0, labels = F, col="lightblue")
axis(side=4, pos= 0, labels = F, col="lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(4)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)

  # Connectar modalitats de variables qualitatives
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)



############### **Variable Dia de la setmana**
plot(Psi[,1],Psi[,2],type="n",xlim=c(-0.2,0.2), ylim=c(-0.4,0.2),
     xlab = "CP1: Nombre de persones involucrades", ylab = "CP2: Condicions en què es dona l'accident")
axis(side=1, pos= 0, labels = F, col="lightblue")
axis(side=3, pos= 0, labels = F, col="lightblue")
axis(side=2, pos= 0, labels = F, col="lightblue")
axis(side=4, pos= 0, labels = F, col="lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(5)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)

  # Connectar modalitats de variables qualitatives
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)





############### **Variable HIHAMORTS**
plot(Psi[,1],Psi[,2],type="n",xlim=c(-0.7,0.5), ylim=c(-0.5,0.8),
     xlab = "CP1: Nombre de persones involucrades", ylab = "CP2: Condicions en què es dona l'accident")
axis(side=1, pos= 0, labels = F, col="lightblue")
axis(side=3, pos= 0, labels = F, col="lightblue")
axis(side=2, pos= 0, labels = F, col="lightblue")
axis(side=4, pos= 0, labels = F, col="lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(11)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)

  # Connectar modalitats de variables qualitatives
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)





############### **Variable Hora grupada**
plot(Psi[,1],Psi[,2],type="n",xlim=c(-0.3,0.3), ylim=c(-1,1),
     xlab = "CP1: Nombre de persones involucrades", ylab = "CP2: Condicions en què es dona l'accident")
axis(side=1, pos= 0, labels = F, col="lightblue")
axis(side=3, pos= 0, labels = F, col="lightblue")
axis(side=2, pos= 0, labels = F, col="lightblue")
axis(side=4, pos= 0, labels = F, col="lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(12)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)

  # Connectar modalitats de variables qualitatives
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)




############### **Variable Setmana**
plot(Psi[,1], Psi[,2], type = "n", xlim = c(-1,1), ylim = c(-0.2,0.2),
     xlab = "CP1: Nombre de persones involucrades",
     ylab = "CP2: Condicions en què es dona l'accident")
axis(side = 1, pos = 0, labels = F, col = "lightblue")
axis(side = 3, pos = 0, labels = F, col = "lightblue")
axis(side = 2, pos = 0, labels = F, col = "lightblue")
axis(side = 4, pos = 0, labels = F, col = "lightblue")
# Afegir projeccions numèriques en segon pla
arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
text(X,Y,labels=etiq,col="gray", cex=0.7)
# Afegir variables qualitatives ordinals
dordi<-c(13)
accident[,dordi[1]] <- factor(accident[,dordi[1]], ordered=TRUE)

c<-1
col<-1
for(k in dordi){
  seguentColor<-colors[col]
  fdic1 = tapply(Psi[,1],accident[,k],mean)
  fdic2 = tapply(Psi[,2],accident[,k],mean)

  # Connectar modalitats de variables qualitatives
  lines(fdic1,fdic2,pch=16,col=seguentColor)
  text(fdic1,fdic2,labels=levels(accident[,k]),col=seguentColor, cex=0.6)
  c<-c+1
  col<-col+1
}
legend("topleft",names(accident)[dordi],pch=1,col=colors[1:length(dordi)], cex=0.6)
