#tutorial from: https://peat-clark.github.io/BIO381/veganTutorial.html

install.packages("vegan")
library(vegan)

data(package = "vegan") ## names of data sets in the package
data(dune) # Vegetation and Environment in Dutch Dune Meadows
str(dune) #a data frame of observations of 30 species at 20 sites

diversity(dune,index = "simpson") # calculate Simpson's 1-D Index of Diversity for each site. # closer to 1 = greater diversity

simpson <- diversity(dune, "simpson") # or assign to var.
simpson 

shannon <- diversity(dune) # note that Shannon's is default, that means it will apply Shannon if you don't specify the index
shannon #Typically ranges from 1.5 - 3.4, higher = more diverse 

# lets compare the two
par(mfrow = c(1, 2))  # use par to generate panels with 1 row of 2 graphs
hist(simpson)
hist(shannon)

#estimates of dissimilarity between community pairs
par(mfrow = c(1, 2))
bray = vegdist(dune, "bray") #Bray-Curtis does not include joint absences 
gower = vegdist(dune, "gower") #Gower includes joint absences
hist(bray, xlim = range(0.0,1.0))
hist(gower, xlim = range(0.0,1.0))
bray #shows the matrix with the values
gower #shows the matrix with the values

#building rarefactions curves and estimating species richness
spAbund <- rowSums(dune)  #gives the number of individuals found in each plot
spAbund # view observations per plot 

raremin <- min(rowSums(dune))  #rarefaction uses the smallest number of observations per sample to extrapolate the expected number if all other samples only had that number of observations
raremin # view smallest # of obs (site 17)

sRare <- rarefy(dune, raremin) # now use function rarefy (raremin can be replaced by another number, as long as it is equal or smaller than the smallest sample size)
sRare #gives an "expected"rarefied" number of species (not obs) if only 15 individuals were present

par(mfrow = c(1,1))
tidyrare <- rarecurve(dune, tidy = TRUE)
tidyscore <- scores(tidyrare, tidy = TRUE)
library(ggplot2)sssssssss
library(dplyr)
  ggplot()+
  geom_line(data=tidyrare, aes(x=Sample, y=Species, color=Site))+
  geom_text(data = tidyrare %>% #here we need coordinates of the labels
              group_by(Site) %>%
              summarise(max_sp = max(Species),
                        max_sample = max(Sample)), #find endpoint coordinate
              aes(x=max_Sample, y=max_sp, label = Site), check_overlap = TRUE, hjust = 0) +
  theme_bw()
# make a decent ggplot: https://stackoverflow.com/questions/47234809/coloring-rarefaction-curve-lines-by-metadata-vegan-package-phyloseq-package
rarecurve(dune, col = "blue") # produces rarefaction curves 
# squares are site numbers positioned at observed space. To "rarefy" a larger site, follow the rarefaction curve until the curve corresponds with the lesser site obs. This gives you rarefied species richness

#NON-METRIC MULTIDIMENSIONAL SCALING (NMDS)

set.seed(2) # random no. generator / way to specify seeds
community_matrix=matrix(
  sample(1:100,300,replace=T),nrow=10, # counts up to 100, 300 cells
  dimnames=list(paste("community",1:10,sep=""),paste("sp",1:30,sep="")))
head(community_matrix)
list(community_matrix)

example_NMDS=metaMDS(community_matrix, # Our community-by-species matrix
                     k=2) # The number of reduced dimensions. Increase if high stress is problem. 
#"The stress, or the disagreement between 2-D configuration and predicted values from the regression"

#A good rule of thumb: stress > 0.05 provides an excellent representation in reduced dimensions, > 0.1 is great, >0.2 is good/ok, and stress > 0.3 provides a poor representation

plot(example_NMDS)

ordiplot(example_NMDS,type="n") #Ordination plot function especially for congested plots
orditorp(example_NMDS,display="species",col="red",air=0.01) #The function adds text or points to ordination plots
orditorp(example_NMDS,display="sites",cex=1.25,air=0.01)

treat=c(rep("Treatment1",5),rep("Treatment2",5))
ordiplot(example_NMDS,type="n")
ordihull(example_NMDS,groups=treat,draw="polygon",col="grey90",label=F)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",5),rep("blue",5)),
         air=0.01,cex=1.25)

#spider plot
ordiplot(example_NMDS,type="n")
ordispider(example_NMDS,groups=treat)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",5),rep("blue",5)),
         air=0.01,cex=1.25)

# Define random elevations for previous example
elevation=runif(10,0.5,1.5)
# Use the function ordisurf to plot contour lines
ordisurf(example_NMDS,elevation,main="",col="forestgreen")

# Finally, display species on plot
orditorp(example_NMDS,display="species",col="grey30",air=0.1,
         cex=1)



#This is the end of the tutorial, now we will apply this to our own data
##########################################################################





library(vegan)
install.packages("readxl")    # To read Excel files into R
library(readxl)

community<- read_excel("Practice/Diversity_test_data.xlsx", sheet = "Test")
list(community)
#columns for species need to be specified because we also have other variables in the datasheet
diversity(community[,3:11],index = "simpson") # calculate Simpson's 1-D Index of Diversity for each site. # closer to 1 = greater diversity

simpson <- diversity(community[3:11], "simpson") # or assign to var.
simpson

shannon <- diversity(community[3:11]) # note that Shannon's is default, that means it will apply Shannon if you don't specify the index
shannon #Typically ranges from 1.5 - 3.4, higher = more diverse 

# lets compare the two
par(mfrow = c(1, 2))  # use par to generate panels with 1 row of 2 graphs
hist(simpson)
hist(shannon)

#estimates of dissimilarity between community pairs
par(mfrow = c(1, 2))
bray = vegdist(community[3:11], "bray") #Bray-Curtis does not include joint absences 
gower = vegdist(community[3:11], "gower") #Gower includes joint absences
hist(bray, xlim = range(0.0,1.0))
hist(gower, xlim = range(0.0,1.0))
bray #shows the matrix with the values
gower #shows the matrix with the values

#building rarefactions curves and estimating species richness
spAbund <- rowSums(community[,3:11])  #gives the number of individuals found in each plot
spAbund # view observations per plot 

raremin <- min(rowSums(community[3:11]))  #rarefaction uses the smallest number of observations per sample to extrapolate the expected number if all other samples only had that number of observations
raremin # view smallest # of obs (site 5)

sRare <- rarefy(community[1,3:11], raremin) # now use function rarefy
sRare #gives an "expected"rarefied" number of species (not obs) if only 5 individuals were present

par(mfrow = c(1,1))
rarecurve(as.data.frame(community[,3:11]), col = "blue") # produces rarefaction curves 
# squares are site numbers positioned at observed space. To "rarefy" a larger site, follow the rarefaction curve until the curve corresponds with the lesser site obs. This gives you rarefied species richness



#NON-METRIC MULTIDIMENSIONAL SCALING (NMDS)


example_NMDS=metaMDS(community[3:11], k=2) 
#A good rule of thumb: stress > 0.05 provides an excellent representation in reduced dimensions, > 0.1 is great, >0.2 is good/ok, and stress > 0.3 provides a poor representation

plot(example_NMDS)

ordiplot(example_NMDS,xlim=c(-1.4,0.8),ylim=c(-0.7,0.7),type="n") #Ordination plot function especially for congested plots
orditorp(example_NMDS,display="species",col="red",air=0.01) #The function adds text or points to ordination plots
orditorp(example_NMDS,display="sites",cex=1.25,air=0.01)

##Grouping per block:

treat=c(rep("Corridor",4),rep("Nord",12),rep("Sud",12))
ordiplot(example_NMDS,xlim=c(-1.4,0.8),ylim=c(-0.7,0.7),type="n")
ordihull(example_NMDS,groups=treat,draw="polygon",col="grey90",label=T)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",4),rep("blue",12),rep("purple",12)),
         air=0.01,cex=1.25)

#spider plot
ordiplot(example_NMDS,xlim=c(-1.4,0.8),ylim=c(-0.7,0.7),type="n")
ordispider(example_NMDS,groups=treat)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",4),rep("blue",12),rep("purple",12)),xlim=c(-0.9,0.7),ylim=c(-0.5,0.5),
         air=0.01,cex=1.25)

#Grouping per locality:
treat=c(rep("Ancien lot de Marius",2),rep("Anketrevo",2),rep("Ambadira",7),rep("Ambatomainty Kiboy",1),rep("Ancien lot de Corine",2),rep("Salapeno Kiboy",2),rep("Bevahy Ankoraobato",1),rep("Kirindy CFPF",9),rep("Marofandilia",2))
ordiplot(example_NMDS,xlim=c(-1.4,0.8),ylim=c(-0.7,0.7),type="n")
ordihull(example_NMDS,groups=treat,draw="polygon",col="grey90",label=T)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",4),rep("blue",12),rep("purple",12)),
         air=0.01,cex=1.25)

#spider plot
ordiplot(example_NMDS,xlim=c(-1.4,0.8),ylim=c(-0.7,0.7),type="n")
ordispider(example_NMDS,groups=treat)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",col=c(rep("green",4),rep("blue",12),rep("purple",12)),
         air=0.01,cex=1.25)

#if you have a continuous variable, you can plot it as contour lines instead of polygons. Here is an example with elevation data.
#you can interpret these lines like a third dimension in the graph
elev = community$elevation
# Use the function ordisurf to plot contour lines
ordisurf(example_NMDS,elev,main="",col="forestgreen")

# Finally, display species on plot
orditorp(example_NMDS,display="species",col="grey30",air=0.1, cex=1)
orditorp(example_NMDS,display="sites",col="grey30",air=0.1, cex=1.5)

#The NMDS displays the data graphically, now we can use PERMANOVA (Permutational Multivariate Analysis of Variance) for statistical tests:

#the command adonis2 performs PERMANOVA, which does not assume normal distribution or equality of variances, but is sensitive to unbalanced designs. Thus, we need to be careful here because we have less samples for "corridor"
#adonis2 allows the use of both continuous and categorical variables. For categorical ones, it uses the distances to centroids. For continuous, it uses the real values. 

adonis2(formula=community[,3:11]~community$elevation)

adonis2(formula=community[,3:11]~community$elevation*community$block)


