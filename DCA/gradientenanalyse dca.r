#### import data ####
library(readxl)
wasserstand2013_2022 <- read_xlsx("1929-2023_Wasserstande_Lenzen_Tageswerte.xlsx", range = "A30382:B34033", col_names = c("Datum", "Wasserstand"))
spec <- read_xlsx("auswertung_transsekt+auengrunland_sose2023+(Gruppe_3+4_fertig).xlsx", range = "A16:AC65", col_names = TRUE)

#### data preperation ####
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(purrr)

spec <- spec %>% select(-c(2,3,4,5))
dim(spec)
londo <- as.character(str_detect(names(spec), "f"))
spec <- spec %>% select(c(1,which(londo == "TRUE"))) # entfernen londo daten
spec <- spec %>% mutate(across(where(is.character), str_trim)) 
spec.t <- as.tibble(t(spec))# transposition
colnames(spec.t)  <- as.vector(spec.t[1,])
spec.t <- spec.t[2:13,]# artenname als colname
spec.t <- spec.t %>% mutate(across(where(is.character), str_trim))
spec.t <- mutate_all(spec.t, function(x){
  as.numeric(as.character(x))
})
spec.t[is.na(spec.t)] <- 0 # na als 0

env <- as.tibble(names(spec)[2:13])
env <- env %>% 
  mutate(Lage = replace(value, str_detect(value, "o"), "Oben")) %>%
  mutate(Lage = replace(Lage, str_detect(Lage, "m"), "Mitte")) %>%
  mutate(Lage = replace(Lage, str_detect(Lage, "u"), "Unten")) %>%
  mutate(value = replace(value, str_detect(value, "1"), "1")) %>%
  mutate(value = replace(value, str_detect(value, "2"), "2")) %>%
  mutate(value = replace(value, str_detect(value, "3"), "3")) %>%
  mutate(value = replace(value, str_detect(value, "4"), "4"))
#import plot art

bdf <- read_xlsx("auswertung_transsekt+auengrunland_sose2023+(Gruppe_3+4_fertig).xlsx", range = "G11:AB11", col_names = FALSE)
bdf <- bdf %>% gather() %>% filter(!is.na(value)) %>% select(2) #import bodenfeuchtigkeit

h <- read_xlsx("auswertung_transsekt+auengrunland_sose2023+(Gruppe_3+4_fertig).xlsx", range = "G12:AB12", col_names = FALSE)
h <- h %>% gather() %>% filter(!is.na(value)) %>% select(2) #import gelaenderhoehe

env <- bind_cols(env, bdf, h)
colnames(env) <- c("Gruppe", "Lage", "Bodenfeuchtigkeit", "Gelaenderhoehe") #unite env data

env$Gelaenderhoehe <- env$Gelaenderhoehe + 352 # in absoluten Hoehe (Wasserhöhe 19.4 = 352)
env <- env %>% 
  mutate(Uberflutungstag = sapply(Gelaenderhoehe, function (x) round(sum(wasserstand2013_2022$Wasserstand[wasserstand2013_2022$Wasserstand] > x)/10, digits = 0)))
# calculate average flodding freqeuncy (for dca)

wasserstand2013_2022$Datum <- as.Date(wasserstand2013_2022$Datum)
wasserstand2013_2022 <- wasserstand2013_2022 %>%
  mutate(year = format(Datum, "%Y"))
wasserstand <- split(wasserstand2013_2022, f = wasserstand2013_2022$year)


#### Stat. Analysis ####
library(rstatix)
shapiro_test(env$Gelaenderhoehe) # -> normal distribution
shapiro_test(env$Uberflutungstag) # -> non-normal distribution
# -> Spearman test for correlation
env %>% cor_test(Gelaenderhoehe, Uberflutungstag, method = "spearman")

#### Visualize Data ####
library(ggplot2)
env %>%
  group_by(Lage) %>%
  summarise_each(funs(mean)) %>%
  mutate(Gruppe = "Avg") %>%
  bind_rows(env) %>%
  ggplot(aes(Gruppe, Uberflutungstag, fill = Gruppe)) +
  geom_col() +
  facet_grid(.~factor(Lage, levels = c("Oben", "Mitte", "Unten"))) +
  theme_minimal() +
  scale_fill_brewer(palette = "Spectral") +
  labs(
    title = "Überflutungshäufigkeit",
    subtitle = "Mit Wasserstandsdaten aus 2022"
  ) +
  ylab("Überflutungshäufigkeit (Tag pro Jahr)") +
  xlab("Lage") # Uberflutungshaufigkeit graphisch dargestellt

#### Calculate Ordination ####
library(vegan)
ord <- decorana(spec.t)
summary(ord)

#### Visualize Ordination ####
attach(env)
plot(ord, type ="n")
ordisurf(ord, Uberflutungstag, add = TRUE)
plot(envfit(ord ~ Bodenfeuchtigkeit, perm = 999), cex = 0.8)
plot(envfit(ord ~ Uberflutungstag, perm = 999), cex = 0.8)
plot(envfit(ord ~ Gelaenderhoehe, perm = 999), cex = 0.8)
points(ord, display = "spec", pch = 3, col = "green4", cex = 1)
sitescol <- c("khaki2", "palegreen", "steelblue")
with(env, points(ord, disp = "sites", pch = 21, col = "black", bg = sitescol, cex = 1))
sitesname <- c("Oben", "Mitte", "Unten")
with(env, legend("topright", legend = sitesname, col = "black", pch = 21, pt.bg = sitescol, cex = 0.6))

# left top
attach(env)
plot(ord, type ="n", xlim = c(-2,0), ylim = c(1,3))
ordisurf(ord, Uberflutungstag, add = TRUE)
plot(envfit(ord ~ Bodenfeuchtigkeit, perm = 999), cex = 0.8)
plot(envfit(ord ~ Uberflutungstag, perm = 999), cex = 0.8)
text(ord, display = "spec", pch = 3, col = "green4", cex = 0.5)
sitescol <- c("khaki2", "palegreen", "steelblue")
with(env, points(ord, disp = "sites", pch = 21, col = "black", bg = sitescol, cex = 1))
sitesname <- c("Oben", "Mitte", "Unten")
with(env, legend("topright", legend = sitesname, col = "black", pch = 21, pt.bg = sitescol, cex = 0.6))

# links oben
attach(env)
plot(ord, type ="n", xlim = c(-2,0), ylim = c(1,3))
ordisurf(ord, Uberflutungstag, add = TRUE)
plot(envfit(ord ~ Bodenfeuchtigkeit, perm = 999), cex = 0.8)
plot(envfit(ord ~ Uberflutungstag, perm = 999), cex = 0.8)
text(ord, display = "spec", pch = 3, col = "green4", cex = 1.4)
sitescol <- c("khaki2", "palegreen", "steelblue")
with(env, points(ord, disp = "sites", pch = 21, col = "black", bg = sitescol, cex = 1.6))
sitesname <- c("Oben", "Mitte", "Unten")
with(env, legend("topright", legend = sitesname, col = "black", pch = 21, pt.bg = sitescol, cex = 1.0))

# links unten
attach(env)
plot(ord, type ="n", xlim = c(-1.8,0.7), ylim = c(-2.5,0))
ordisurf(ord, Uberflutungstag, add = TRUE)
plot(envfit(ord ~ Bodenfeuchtigkeit, perm = 999), cex = 0.8)
plot(envfit(ord ~ Uberflutungstag, perm = 999), cex = 0.8)
text(ord, display = "spec", pch = 3, col = "green4", cex = 1.0)
sitescol <- c("khaki2", "palegreen", "steelblue")
with(env, points(ord, disp = "sites", pch = 21, col = "black", bg = sitescol, cex = 1.4))
sitesname <- c("Oben", "Mitte", "Unten")
with(env, legend("topright", legend = sitesname, col = "black", pch = 21, pt.bg = sitescol, cex = 0.9))

# rechts
attach(env)
plot(ord, type ="n", xlim = c(2,10), ylim = c(-0.5,2))
ordisurf(ord, Uberflutungstag, add = TRUE)
plot(envfit(ord ~ Bodenfeuchtigkeit, perm = 999), cex = 0.8)
plot(envfit(ord ~ Uberflutungstag, perm = 999), cex = 0.8)
text(ord, display = "spec", pch = 3, col = "green4", cex = 1.0)
sitescol <- c("khaki2", "palegreen", "steelblue")
with(env, points(ord, disp = "sites", pch = 21, col = "black", bg = sitescol, cex = 1))
sitesname <- c("Oben", "Mitte", "Unten")
with(env, legend("topright", legend = sitesname, col = "black", pch = 21, pt.bg = sitescol, cex = 1.0))
