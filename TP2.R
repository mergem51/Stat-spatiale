install.packages("sf")
library("sf")
library("dplyr")

# 1 importation

comm_frmetro <- st_read("commune_francemetro_2021.shp", options = "ENCODING=WINDOWS-1252")

# 2 résumé 

summary(comm_frmetro)

# 3 visualisation 

View(comm_frmetro[1:10, ])
View(comm_frmetro[,ncol(comm_frmetro)])

# 4 système de projection

projection <- st_crs(comm_frmetro)
print(comm_frmetro)

# 5

communes_Bretagne <- comm_frmetro %>%
  filter(dep %in% c(35, 56, 22, 29)) %>%
  select(code, libelle, epc, dep, surf)

# 6

class(communes_Bretagne)
class(comm_frmetro)

# 7

plot(communes_Bretagne, lwd = 0.5)

# 8
plot(st_geometry(communes_Bretagne), lwd = 0.5)

# 9

communes_Bretagne$surf2 <- st_area(communes_Bretagne$geometry)
class(communes_Bretagne$surf2)

# 10

mutate(surf2) %>% 
  mutate(surf2 = units::set_units(surf2, "km^2"))
