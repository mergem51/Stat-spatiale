## exo 2

library(dplyr)
library(sf)
library(mapsf)
library(classInt)
library(leaflet)
library(readxl)


# import bdd 

dep_fm<- st_read("dep_francemetro_2021.shp", options = "ENCODING=WINDOWS-1252") 
taux_pauv <- read_excel("Taux_pauvrete_2018.xlsx")  

taux_pauv <- taux_pauv[-c(97:101),]
colnames(taux_pauv)[1] = "code"

dep_pauv_fm <- full_join(dep_fm,taux_pauv, by ="code")
dep_pauv_fm_reduit <- dep_pauv_fm %>% 
  filter(code %in% c(75, 92, 93, 94))

# visualisation 

mtq <- mf_get_mtq()
mf_map(x = dep_pauv_fm, var = "Tx_pauvrete", type = "choro", breaks = "fisher")
mf_map(x = dep_pauv_fm, var = "Tx_pauvrete", type = "choro", breaks = "quantile")
mf_map(x = dep_pauv_fm, var = "Tx_pauvrete", type = "choro", breaks = "equal")

seuils <- c(0, 13, 17, 25, max(dep_pauv_fm$Tx_pauvrete))
mf_map(x = dep_pauv_fm, var = "Tx_pauvrete", type = "choro", breaks = seuils)

mf_inset_on(x = dep_pauv_fm, pos = "topright", 
            cex = .4)

mf_init(dep_pauv_fm_reduit <- dep_pauv_fm %>% 
          filter(code %in% c(75, 92, 93, 94))
)

mf_map(dep_pauv_fm_reduit, var = "Tx_pauvrete", type = "choro", breaks = seuils, leg.pos = NA, add = TRUE)
mf_inset_off()


# 3

st_write(dep_pauv_fm, file.path("~/work/Stat-spatiale/dept_tx_pauvrete_2018.gpkg))

