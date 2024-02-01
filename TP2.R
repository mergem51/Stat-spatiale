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

mutate(communes_Bretagne$surf2) %>% 
  mutate(surf2 = units::set_units(surf2, "km^2"))

# 11 surf surface réelles

# 12

dept_bretagne <- communes_Bretagne %>%
  group_by(dep) %>%
  summarize(surf_totale = sum(surf))

# 13

fond_departemental <- communes_Bretagne %>%
  group_by(dep) %>%
  summarize(geometry = st_union(geometry))

plot(fond_departemental)

# 14 geometry POINT

centroid_dept_bretagne <- fond_departemental$geometry %>%
  st_centroid() 

# 14.b

plot(st_geometry(fond_departemental))
plot(st_geometry(centroid_dept_bretagne), add = TRUE)

# 14.c

correspondance_dep_lib <- data.frame(
  dep = c(35, 56, 22, 29),
  dep_lib = c("Ille-et-Vilaine", "Morbihan", "Côtes-d'Armor", "Finistère")
)
correspondance_dep_lib$dep <- as.character(correspondance_dep_lib$dep)
fond_departemental <- fond_departemental %>%
  left_join(correspondance_dep_lib, by = "dep")

# 14.d

centroid_coords <- st_coordinates(centroid_dept_bretagne)
centroid_coords <- as.data.frame(centroid_coords)

centroid_coords <- bind_cols(centroid_coords, correspondance_dep_lib[c("dep", "dep_lib")])

plot(st_geometry(fond_departemental))
plot(centroid_dept_bretagne, add = TRUE)
coordonees_centroids <- as.data.frame(st_coordinates(centroid_dept_bretagne))
text(
  x = coordonees_centroids$X,
  y = coordonees_centroids$Y,
  labels = centroid_coords$dep_lib)

# 15

intersection1 <- st_intersects(centroid_dept_bretagne, communes_Bretagne)

# 16

intersection2 <- st_intersection(centroid_dept_bretagne, communes_Bretagne)
within <- st_within(centroid_dept_bretagne, communes_Bretagne)

# 17

chefs_lieux_coords <- data.frame(
  dep = c(22, 29, 35, 56),
  commune = c("Saint-Brieuc", "Quimper", "Rennes", "Vannes")
)

chefs_lieux <- st_sf(
  st_sfc(st_point(c(chefs_lieux_coords$X, chefs_lieux_coords$Y))),
  dep = chefs_lieux_coords$dep,
  commune = chefs_lieux_coords$commune
)

distances <- st_distance(centroid_dept_bretagne, chefs_lieux)



