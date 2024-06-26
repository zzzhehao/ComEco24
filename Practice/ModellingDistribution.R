install.packages("R2WinBUGS")
library(R2WinBUGS)
install.packages("unmarked")
library(unmarked)
library(rjags)
library(jagsUI)
library(nimble)

#https://www.mbr-pwrc.usgs.gov/pubanalysis/keryroylebook/
  
install.packages("AHMbook")
library(AHMbook)


sim.fn(quad.size=10, cell.size=1,intensity=1)

tmp <- sim.fn()
str(tmp)
set.seed(82)
# Effect of grain size of study on abundance and occupancy (intensity constant)
tmp <- sim.fn(quad.size = 10, cell.size = 1, intensity = 0.5)
tmp <- sim.fn(quad.size = 10, cell.size = 2, intensity = 0.5)
tmp <- sim.fn(quad.size = 10, cell.size = 5, intensity = 0.5)
tmp <- sim.fn(quad.size = 10, cell.size = 10, intensity = 0.5)

# Effect of intensity of point pattern (intensity) on abundance and occupancy
tmp <- sim.fn(intensity = 0.1) # choose default quad.size = 10, cell.size = 1
tmp <- sim.fn(intensity = 1)
tmp <- sim.fn(intensity = 5)
tmp <- sim.fn(intensity = 10)

#important remark: this simulation models distribution, but not measurement error. Measurement error can also be modelled, and when we model both distribution and measurement errors, we have HIERARCHICAL MODELS
#measurement error may come from detection failure, false detection (due to identification error, for example), false spatial allocation (in case of animals that move)

#good explanation about bayesian statistics: https://statsthinking21.github.io/statsthinking21-core-site/bayesian-statistics.html