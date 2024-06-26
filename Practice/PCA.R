#script adapted from http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/118-principal-component-analysis-in-r-prcomp-vs-princomp/#google_vignette

install.packages("corrr")
library(corrr)
install.packages("ggcorrplot")
library(ggcorrplot)
install.packages("FactoMineR")
library(FactoMineR)
install.packages("factoextra")
library(factoextra)

#in this case we need species (or functional groups for example) in the columns and sites in the rows (to compare sites among each other)
#species with no records need to be excluded from the datasheet

library(readxl) 

PCAspecies<- read_excel("Practice/PCApractice.xlsx", sheet = "PCApractice_species")
str(PCAspecies)

#the scale function normalizes the data
data_normalized <- scale(PCAspecies[,2:10], center=TRUE, scale=TRUE) #you need to specify just the columns with numbers
head(data_normalized)


data.pca <- prcomp(data_normalized, scale=TRUE)
summary(data.pca)

data.pca$loadings[, 1:2]
fviz_eig(data.pca, addlabels = TRUE)

# Graph of the variables
fviz_pca_var(data.pca, col.var = "black")

fviz_cos2(data.pca, choice = "var", axes = 1:2) #how much each species contributes to differentiate communities

fviz_pca_var(data.pca, col.var = "cos2",
             gradient.cols = c("black", "orange", "green"),
             repel = TRUE)


fviz_pca_ind(data.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

fviz_pca_biplot(data.pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)


# Eigenvalues
eig.val <- get_eigenvalue(data.pca)
eig.val

## Eigenvalue shows in what extent the axis is informativ in terms of representing variablility

# Results for Variables
res.var <- get_pca_var(data.pca)
res.var$coord          # Coordinates
res.var$contrib        # Contributions to the PCs
res.var$cos2           # Quality of representation 
# Results for individuals
res.ind <- get_pca_ind(data.pca)
res.ind$coord          # Coordinates
res.ind$contrib        # Contributions to the PCs
res.ind$cos2           # Quality of representation 



#now testing whether the representation of different functional groups explain differences among communities

PCAfunctional<- read_excel("Practice/PCApractice.xlsx", sheet = "PCApractice_functgroups")
list(PCAfunctional)


#the scale function normalizes the data
data_normalized <- scale(PCAfunctional[2:8], scale=TRUE) #you need to specify just the columns with numbers
head(data_normalized)

data.pca <- prcomp(data_normalized, scale=TRUE)
summary(data.pca)

data.pca$loadings[, 1:2]
fviz_eig(data.pca, addlabels = TRUE)

# Graph of the variables
fviz_pca_var(data.pca, col.var = "black")

fviz_cos2(data.pca, choice = "var", axes = 1:2) #how much each species contributes to differentiate communities

fviz_pca_var(data.pca, col.var = "cos2",
             gradient.cols = c("black", "orange", "green"),
             repel = TRUE)

fviz_pca_ind(data.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

fviz_pca_biplot(data.pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)

# Eigenvalues
eig.val <- get_eigenvalue(data.pca)
eig.val

# Results for Variables
res.var <- get_pca_var(data.pca)
res.var$coord          # Coordinates
res.var$contrib        # Contributions to the PCs
res.var$cos2           # Quality of representation 
# Results for individuals
res.ind <- get_pca_ind(data.pca)
res.ind$coord          # Coordinates
res.ind$contrib        # Contributions to the PCs
res.ind$cos2           # Quality of representation 

## for visualization in other way (coordinate infos)


#INDICATOR SPECIES ANALYSIS

install.packages("indicspecies")
library(indicspecies)

PCAspecies<- read_excel("Practice/PCApractice.xlsx", sheet = "PCApractice_species")
list(PCAspecies)

groups <- as.factor(PCAspecies$sampling_season) #here we just have one entry per stream, so you can choose any variable to classify streams and see if there are species associated to the categories you created 
groups <- as.factor(PCAspecies$Streams)

indsps <- multipatt(PCAspecies[,2:39], groups, 
                    control = how(nperm=999)) 
summary(indsps, indvalcomp=TRUE)


