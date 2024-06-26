install.packages("betapart")

#

library(vegan)
library(betapart)
library(readxl)

#the file should have species in the columns and communities in the rows

community <- read_excel("Practice/Diversity_test_data.xlsx", sheet = "Test")
str(community)
community <- community %>% mutate(site = factor(site), block = factor(block))

#?#here you define your groups: in this case, it is done for "blocks":
groups <- factor(c(rep(1,4), rep(2,12), rep(3,12)), labels = c("Corridor","Nord", "Sud"))
# groups <- community$block

#if you just have presence/absence data, you can use Jaccard or Sorensen indexes (these indexes do not include joint absences)

#this command will transform our data in presence/absence data to test these indexes
presabs<-ifelse(community[4:11]>0,1,0)
#presabs <- community %>% mutate(everything()=)
str(presabs)

dist<-beta.pair(presabs, index.family="sorensen") #you can also test with family="sorensen"
dist[[1]] #shows the amount of turnover between community pairs
dist[[2]] #shows the amount of nestedness between community pairs
dist[[3]] #shows the total beta diversity between community pairs

bd<-betadisper(dist[[3]],groups) #you can also compare each component of beta diversity
plot(bd)
boxplot(bd)
anova(bd)

#now we can test with abundance data (the original datasheet), in this case, we use Bray-Curtis (does not include joint absences)

dist<-bray.part(community[4:11]) #in this case, the function is bray.part
dist[[1]] #shows the amount of turnover between community pairs
dist[[2]] #shows the amount of nestedness between community pairs
dist[[3]] #shows the total beta diversity between community pairs

bd<-betadisper(dist[[3]],groups) #you can also compare each component of beta diversity
plot(bd)
boxplot(bd)
anova(bd)

#### own data ####

tadpole <- read_xls("Data/Kaulquappen Regenwald_Daten.xls", sheet = "streams_tadpoles_matrix")[, -1]
tadpole <- tadpole %>% select_if(~!all(is.na(.))) %>% select(-tail(names(.), 7))
str(tadpole)

tadpole_env <- read_xls("Data/Kaulquappen Regenwald_Daten.xls", sheet = "stream_habitat_matrix")
tadpole_env <- tadpole_env %>% select_if(~!all(is.na(.)))
str(tadpole_env)

# facs <- c('stream', 'site')
# tadpole_env_fac <- tadpole_env %>%
#   mutate_at(vars(facs), .funs = ~ factor(.x))

summary(tadpole_env$`Depth (cm)`)
tadpole_env_fac <- tadpole_env %>% 
  mutate(depth_log = log10(.$`Depth (cm)`), .after = site) %>%
  # mutate(depth_cat = cut(depth_log, breaks = c(-Inf, 0.8367, 1.4231, Inf), labels = c('Deep', 'Middle', 'Shallow'))) 
  mutate(depth_cat = cut(depth_log, breaks = c(-Inf, 0.8367, 0.9468, 1.0661, 1.4231, Inf)))
summary(tadpole_env_fac$depth_log)

tadpoleBin2 <- ifelse(tadpole > 0, 1, 0)
tadpoleBinDis <- beta.pair(tadpoleBin, index.family = "sorensen")
tadpoleBinDis[[1]]
tadpoleBinDis[[2]]
tadpoleBinDis[[3]]
tadpoleBinDisP <- betadisper(tadpoleBinDis[[3]], tadpole_env_fac$depth_cat)
plot(tadpoleBinDisP)
boxplot(tadpoleBinDisP)
anova(tadpoleBinDisP)
