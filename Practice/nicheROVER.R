#Niche breadth and overlap

#A new program: https://cran.r-project.org/web/packages/nicheROVER/vignettes/ecol-vignette.html

install.packages("nicheROVER")
library(nicheROVER)

data(fish) #opens a dataset that comes with the package: good to see how you need to make your data file
aggregate(fish[2:4], fish[1], mean) # isotope means calculated for each species

# generate parameter draws from the "default" posteriors of each species
nsamples <- 1000

fish.par <- tapply(1:nrow(fish), fish$species,
                     function(ii) niw.post(nsamples = nsamples, X = fish[ii,2:4]))

# various parameter plots
clrs <- c("black", "red", "blue", "orange") # colors for each species

# mu1 (del15N), mu2 (del13C), and Sigma12
  # sigma: how the variance/covariance changes
  # how the parameter change from each other
par(mar = c(4, 4, .5, .1)+.1, mfrow = c(1,4))
niche.par.plot(fish.par, col = clrs, plot.index = 1)
niche.par.plot(fish.par, col = clrs, plot.index = 2)
niche.par.plot(fish.par, col = clrs, plot.index = 3)
niche.par.plot(fish.par, col = clrs, plot.index = 2:3)
legend("topleft", legend = names(fish.par), fill = clrs)
  # see help:plot.index i is corresponding with column index probably, 1=C 2= 3=S
  


# 2-d projections of 10 niche regions (10 random pairs from each species posterior distribution)
clrs <- c("black", "red", "blue", "orange") # colors for each species
nsamples <- 10 
fish.par <- tapply(1:nrow(fish), fish$species,
                   function(ii) niw.post(nsamples = nsamples, X = fish[ii,2:4]))

# format data for plotting function
fish.data <- tapply(1:nrow(fish), fish$species, function(ii) X = fish[ii,2:4])

niche.plot(niche.par = fish.par, niche.data = fish.data, pfrac = .05,
           iso.names = expression(delta^{15}*N, delta^{13}*C, delta^{34}*S),
           col = clrs, xlab = expression("Isotope Ratio (per mil)"))
  # scatterplot: present data point (specie-mean?) of each simulation

# niche overlap plots for 95% niche region sizes
nsamples <- 1000
fish.par <- tapply(1:nrow(fish), fish$species,
                   function(ii) niw.post(nsamples = nsamples, X = fish[ii,2:4]))

# Overlap calculation.  use nsamples = nprob = 10000 (1e4) for higher accuracy.
# the variable over.stat can be supplied directly to the overlap.plot function

over.stat <- overlap(fish.par, nreps = nsamples, nprob = 1e3, alpha = c(.95, 0.99))

#The mean overlap metrics calculated across iteratations for both niche 
#region sizes (alpha = .95 and alpha = .99) can be calculated and displayed in an array.
over.mean <- apply(over.stat, c(1:2,4), mean)*100
round(over.mean, 2)

  # niche overlap?

over.cred <- apply(over.stat*100, c(1:2, 4), quantile, prob = c(.025, .975), na.rm = TRUE)
round(over.cred[,,,1]) # display alpha = .95 niche region

# Overlap plot.Before you run this, make sure that you have chosen your 
#alpha level.
clrs <- c("black", "red", "blue", "orange") # colors for each species
over.stat <- overlap(fish.par, nreps = nsamples, nprob = 1e3, alpha = .95)
overlap.plot(over.stat, col = clrs, mean.cred.col = "turquoise", equal.axis = TRUE,
             xlab = "Overlap Probability (%) -- Niche Region Size: 95%")

# posterior distribution of (mu, Sigma) for each species
nsamples <- 1000
fish.par <- tapply(1:nrow(fish), fish$species,
                   function(ii) niw.post(nsamples = nsamples, X = fish[ii,2:4]))

# posterior distribution of niche size by species
fish.size <- sapply(fish.par, function(spec) {
  apply(spec$Sigma, 3, niche.size, alpha = .95)
})

# point estimate and standard error
rbind(est = colMeans(fish.size),
      se = apply(fish.size, 2, sd))

clrs <- c("black", "red", "blue", "orange") # colors for each species
par(mfrow = c(1,1))
boxplot(fish.size, col = clrs, pch = 16, cex = .5,
        ylab = "Niche Size", xlab = "Species")


###########################################

#Adapting the script to our data

library(nicheROVER)

#this is a way to open a datasheet using a txt file (which can be saved from excel)
lizards<-(read.table("Practice/transect11_day.txt",header=TRUE))
#to see the data, click on it at the upper pannel on the right or use the command: 
list(lizards)#all the data
head(lizards) #just the first lines

aggregate(lizards[3:5], lizards[1], mean) # variable means calculated for each species

# generate parameter draws from the "default" posteriors of each species

nsamples <- 1e3
system.time({
  lizards.par <- tapply(1:nrow(lizards), lizards$Species,
                     function(ii) niw.post(nsamples = nsamples, X = lizards[ii,3:5]))
})

# various parameter plots
clrs <- c("green", "red", "blue", "orange", "black","purple") # colors for each species - example with names of colors

# mu1, mu2, and Sigma12
par(mar = c(4, 4, .5, .1)+.1, mfrow = c(1,3))
niche.par.plot(lizards.par, col = clrs, plot.index = 1)
niche.par.plot(lizards.par, col = clrs, plot.index = 2)
niche.par.plot(lizards.par, col = clrs, plot.index = 1:2)
legend("topleft", legend = names(lizards.par), fill = clrs)


# 2-d projections of 10 niche regions (10 random pairs from each species posterior distribution)
clrs <- c("#66FF00", "#FF99FF", "#3366FF", "#FF3300", "#FFCC33","#660066") # colors for each species - example with color codes
nsamples <- 10 #you can try with different numbers of samples to see how the graphic looks
lizards.par <- tapply(1:nrow(lizards), lizards$Species,
                   function(ii) niw.post(nsamples = nsamples, X = lizards[ii,3:5]))

# format data for plotting function
lizards.data <- tapply(1:nrow(lizards), lizards$Species, function(ii) X = lizards[ii,3:5])

niche.plot(niche.par = lizards.par, niche.data = lizards.data, pfrac = .05,
           iso.names = expression(Distance, Height, Time),
           col = clrs, xlab = expression("Use of transect 11 in Ambadira"))
legend(x=1, y=1, "topleft", legend = names(lizards.par), fill = clrs)


# niche overlap plots for 95% niche region sizes
nsamples <- 1000
lizards.par <- tapply(1:nrow(lizards), lizards$Species,
                   function(ii) niw.post(nsamples = nsamples, X = lizards[ii,3:5]))

# Overlap calculation.  use nsamples = nprob = 10000 (1e4) for higher accuracy.
# the variable over.stat can be supplied directly to the overlap.plot function

over.stat <- overlap(lizards.par, nreps = nsamples, nprob = 1e3, alpha = c(.95, 0.99))

#The mean overlap metrics calculated across iteratations for both niche region sizes (alpha = .95 and alpha = .99) can be calculated and displayed in an array.
over.mean <- apply(over.stat, c(1:2,4), mean)*100
round(over.mean, 2)

over.cred <- apply(over.stat*100, c(1:2, 4), quantile, prob = c(.025, .975), na.rm = TRUE)
round(over.cred[,,,1]) # display alpha = .95 niche region

# Overlap plot.Before you run this, make sure that you have chosen your alpha level.
clrs <- c("#66FF00", "#FF99FF", "#3366FF", "#FF3300", "#FFCC33","#660066") # colors for each species
over.stat <- overlap(lizards.par, nreps = nsamples, nprob = 1e3, alpha = .95)
overlap.plot(over.stat, col = clrs, mean.cred.col = "turquoise", equal.axis = TRUE,
             xlab = "Overlap Probability (%) -- Niche Region Size: 95%")

# posterior distribution of (mu, Sigma) for each species
nsamples <- 1000
lizards.par <- tapply(1:nrow(lizards), lizards$Species,
                   function(ii) niw.post(nsamples = nsamples, X = lizards[ii,3:5]))

# posterior distribution of niche size by species
lizard.record <- sapply(lizards.par, function(spec) {
  apply(spec$Sigma, 3, niche.size, alpha = .95)
})

# point estimate and standard error
rbind(est = colMeans(lizard.record),
      se = apply(lizard.record, 2, sd))

clrs <- c("#66FF00", "#FF99FF", "#3366FF", "#FF3300", "#FFCC33","#660066") # colors for each species

par(mfrow = c(1,1))
boxplot(lizard.record, col = clrs, pch = 16, cex = .5,
        ylab = "Niche Size", xlab = "Species", ncol = 1, nrow = 1)

