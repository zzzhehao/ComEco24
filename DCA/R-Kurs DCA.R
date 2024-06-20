# Daten importieren

floodplain.env <- read.table("/Users/hu_zhehao/Library/Mobile Documents/com~apple~CloudDocs/UHH/B.Sc. Biologie/2023 SoSe/Freilandöko/Auswertung/R Übung/floodplainWET_env.csv", sep=";", header = TRUE)
floodplain.spec <- read.table("/Users/hu_zhehao/Library/Mobile Documents/com~apple~CloudDocs/UHH/B.Sc. Biologie/2023 SoSe/Freilandöko/Auswertung/R Übung/floodplainWET_spec.csv", sep=";", header = TRUE)
#What was wrong here? Didaktischen Fehler hier gel?scht.


dim(floodplain.env)
floodplain.env # alles
head(floodplain.env) # nur der Anfang der Tabelle
tail(floodplain.env) # nur das Ende der Tabelle

summary(floodplain.env)
str(floodplain.spec)

max(floodplain.env$Prec7100)
min(floodplain.env$Prec7100)
mean(floodplain.env$Prec7100)

prec.sort <- sort(floodplain.env$Prec7100)
tail(prec.sort)

mean.cover<-colMeans(floodplain.spec)
mean.cover.sort<-sort(mean.cover)
head(mean.cover.sort)
tail(mean.cover.sort)

#DCA
library(vegan)
ord <- decorana(floodplain.spec)
ord
summary(ord)

#Plotting 
attach(floodplain.env)

plot(ord, type="n")
points(ord, disp="sites", pch=21, col="red", bg="yellow", cex=1.3)
ordiellipse(ord, Habitat, col="dodgerblue4", conf=0.7, lwd=1.5)

plot(ord, type="n")
points(ord, disp="sites", pch=23, col="black", bg="chocolate1", cex=1.3)
ordiellipse(ord, Habitat, col="red4", conf=0.9, lwd=1.5, label=TRUE)

colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2", "darkred")
leg.txt<-c("Bleckede", "Strachau", "Schnackenburg", "Fischbeck", "Steckby", "W?rlitz")
plot(ord, type = "n")
with(floodplain.env, points(ord, display = "sites", col = "black", pch = 21, bg = colvec[order], cex=1.5 ))
with(floodplain.env, legend("topright", legend = leg.txt, bty = "n",
                      col = "black", pch = 21, pt.bg = colvec))
ordispider(ord, Habitat, col="red", label = TRUE)

text(ord, display = "species", cex = 0.6, col = "grey2")

##umweltvariablen ?berblick alle
ord.fit <- envfit(ord ~ P_summer, data=floodplain.env, perm=999)
ord.fit
plot(ord.fit)
ordisurf(ord, P_summer, add=TRUE)



#Plotting 3D
library(vegan3d)
colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2", "darkred")
colvec2 <- c("white")
if (interactive() && require(rgl, quietly = TRUE)) {
  ord <- decorana(floodplain.spec)
  ordirgl(ord, size=4, col = "yellow")
  with(floodplain.env, ordirgl(ord, col = colvec[order], scaling = 1))
  with(floodplain.env, orglspider(ord, Combi, col = colvec2[Combi], scaling = 1))
  with(floodplain.env, orglellipse(ord, Combi, col = colvec2[Combi], kind = "se", conf = 0.95,
                                   scaling = 1))
}

##2. Fitting environmental variables
floodplainWET.env <- read.table("C:/Users/schulz-b/Desktop/floodplain_data/floodplainWET_env.csv", sep=";", header = TRUE)
floodplainWET.spec <- read.table("C:/Users/schulz-b/Desktop/floodplain_data/floodplainWET_spec.csv", sep=";", header = TRUE)

ord <- decorana(floodplainWET.spec)

colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2", "darkred")
colvec2 <- c("white")
if (interactive() && require(rgl, quietly = TRUE)) {
  ord <- decorana(floodplainWET.spec)
  ordirgl(ord, size=4, col = "yellow")
  with(floodplainWET.env, ordirgl(ord, col = colvec[order], scaling = 1))
  with(floodplainWET.env, orglspider(ord, Location, col = colvec2[Location], scaling = 1))
  }

#Fitting environmental variables(enfit -> f?r continous und class vektoren)
colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2")
leg.txt<-c("Bleckede", "Strachau", "Schnackenburg", "Fischbeck", "Steckby")
plot(ord, dis="sites", type = "n")
with(floodplainWET.env, points(ord, display="sites", col = "black", pch = 21, bg = colvec[order], cex=1.5 ))
with(floodplainWET.env, legend("topright", legend = leg.txt, bty = "n",
                            col = "black", pch = 21, pt.bg = colvec))
title(main = "Einfluss der Kontinentalit?t in feuchten Stromtalwiesen")



attach(floodplainWET.env)
ord.fit <- envfit(ord ~ Temp7100+Prec7100+Flood_d, data=floodplainWET.env, perm=999)
ord.fit
plot(ord.fit)

#Fitting environmental variables(ordisurf -> nur f?r continous vektoren)
ord.fit <- envfit(ord ~ Prec7100, data=floodplainWET.env, perm=999)
ord.fit
plot(ord.fit)

#Fitting environmental variables(ordisurf -> nur f?r continous vektoren)
attach(floodplainWET.env)
ordisurf(ord, Prec7100, add=TRUE)



##3.Tei Fitting environmental variables to MESIC
floodplainMESIC.env <- read.table("C:/Users/schulz-b/Desktop/floodplain_data/floodplainMESIC_env.csv", sep=";", header = TRUE)
floodplainMESIC.spec <- read.table("C:/Users/schulz-b/Desktop/floodplain_data/floodplainMESIC_spec.csv", sep=";", header = TRUE)

ord <- decorana(floodplainMESIC.spec)

colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2", "darkred")
colvec2 <- c("white")
if (interactive() && require(rgl, quietly = TRUE)) {
  ord <- decorana(floodplainMESIC.spec)
  ordirgl(ord, size=4, col = "yellow")
  with(floodplainMESIC.env, ordirgl(ord, col = colvec[order], scaling = 1))
  with(floodplainMESIC.env, orglspider(ord, Location, col = colvec2[Location], scaling = 1))
}

#Fitting environmental variables(enfit -> f?r continous und class vektoren)
colvec <- c("olivedrab1", "olivedrab", "darkorange", "orangered2", "firebrick2", "darkred")
leg.txt<-c("Bleckede", "Strachau", "Schnackenburg", "Fischbeck", "Steckby", "W?rlitz")
plot(ord, dis="sites", type = "n")
with(floodplainMESIC.env, points(ord, display="sites", col = "black", pch = 21, bg = colvec[order], cex=1.5 ))
with(floodplainMESIC.env, legend("topright", legend = leg.txt, bty = "n",
                               col = "black", pch = 21, pt.bg = colvec))

attach(floodplainMESIC.env)
ord.fit <- envfit(ord ~ Temp7100+Prec7100+Flood_d+P_spring+P_summer, data=floodplainMESIC.env, perm=999)
ord.fit
plot(ord.fit)

#Fitting environmental variables(ordisurf -> nur f?r continous vektoren)
ord.fit <- envfit(ord ~ Temp7100, data=floodplainMESIC.env, perm=999)
ord.fit
plot(ord.fit)

#Fitting environmental variables(ordisurf -> nur f?r continous vektoren)
ordisurf(ord, Temp7100, add=TRUE)

