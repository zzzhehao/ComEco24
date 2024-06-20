#installing packages (you will need to choose a repository, that's from where you will download the package)
install.packages("MASS") #for lda function
install.packages("tidyverse") #for data manipulation and visualization


#once the package is installed, you need to activate it in each session of R
library(MASS)
library(tidyverse)

#this is a way to open a datasheet using a txt file (which can be saved from excel)
lizards<-(read.table("/Users/hu_zhehao/Library/Mobile Documents/com~apple~CloudDocs/Files/Obsidian/Cafe AgX HQ 2.0/004 Notes/M.Sc. Biology/Community Ecology/Practice/1-1/transect11_day.txt",header=TRUE))
#to see the data, click on it at the upper pannel on the right or use the command: 
list(lizards) #all the data
head(lizards) #just the first lines


#with this command you see a summary of the data and you can also check whether R is recognizing your quantitative and qualitative variables as wanted
summary(lizards)

#doing the discriminant analysis based on lizard habitat use
bartlett.test(lizards$distance + lizards$height + lizards$time ~ lizards$Species, data=lizards)
#if p>0.05 we can't reject the null hypothesis (variance is equal among groups)
#if p<0.05 we assume that data is not normal

fit <- lda(Species ~ distance + height + time, data=lizards, na.action="na.omit", CV=TRUE)
#na.action specifies what to do with variables with missing values. na.omit excludes samples with missing values and proceeds with the analyses.
#if such samples exist but na.action is not specified, the analysis won't run (default option)
#CV
fit # show results 

# Assess the accuracy of the prediction 
ct <- table(lizards$Species, fit$class)
diag(prop.table(ct, 1))

#this will give you the probability of getting a random lizard and assigning it to the correct species only based on its habitat use data
sum(diag(prop.table(ct)))


model <- lda(Species ~ distance + height + time, data=lizards)
model



plot(model, dimen = 2)

plot(model, dimen = 1, type = "b")

library (ggplot2)
lizard.lda.values <- predict(model)

plot(lizard.lda.values$x[,1],lizard.lda.values$x[,2])
plotdata <- data.frame(type=lizards[,1],lda=lizard.lda.values$x)
ggplot(plotdata) + geom_point(aes(lda.LD1,lda.LD2, colour = lizards$Species), size = 2.5)
