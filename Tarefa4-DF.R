# O código com os estado de Goiás está comentado porque estava demorando muito
# e não cosnegui melhorar a performance

if (!require ("pacman")) install.packages ("pacman")
pacman::p_load(sf , tidyverse , hrbrthemes , lwgeom , rnaturalearth , maps , mapdata , terra
               , spData , tigris , leaflet , mapview , tmap , tmaptools )

library(raster)
library("geobr")


wd <- "C:/Users/Catarina/Documents/CienciaDados/20220222 Tarefa4/Mapas-Tarefa4/"
setwd(wd)
raster_file_2020 = raster(paste0(wd,"brasil_coverage_2020.tif"), package = "spDataLarge")

cod_floresta    = c(1,3,4,5,49)
cod_ant_ex_flor = c(10,11,12,32,29,13)
cod_veg_nat     = c(cod_floresta, cod_ant_ex_flor)
cod_agropec     = c(14,15,18,19,39,20,40,41,36,46,47,48,9,21)
cod_outros      = c(22,23,24,30,25,26,33,31,27)
  
mun <- read_municipality (year=2020)
DF <- mun %>% filter(abbrev_state == "DF")
GO <- mun %>% filter(abbrev_state == "GO")

crop_df_2020 =crop(raster_file_2020, DF)
mask_df_2020 = mask(crop_df_2020, DF)


df_pts_2020 <- rasterToPoints(mask_df_2020, spatial = TRUE)
raster_df_2020  <- data.frame(df_pts_2020)

ggplot() +
  geom_raster(data = raster_df_2020 , aes(x = x, y = y, fill = brasil_coverage_2020)) + 
  ggtitle("Cobertura DF 2020") + 
  theme(legend.position = "none", panel.background = element_rect(fill = "transparent",colour = NA)) +
  coord_equal()

raster_df_2020

tab_veg <- raster_df_2020 %>% count(brasil_coverage_2020)
veg_total <- unlist(tab_veg %>% summarise(sum(n)))

veg_natural <- unlist(tab_veg %>% filter(brasil_coverage_2020 %in% cod_veg_nat) %>% 
               summarise(sum(n)))

agropec <- unlist(tab_veg %>% filter(brasil_coverage_2020 %in% cod_agropec) %>% 
  summarise(sum(n)))

tabela <- data.frame(per_veg_nat    = numeric()
                     , perc_agropec = numeric()
                     , perc_outros  = numeric())

tabela = cbind(round(veg_natural/veg_total*100, digits = 2)
              , round(agropec/veg_total*100, digits = 2)
              , round((1-(veg_natural+agropec)/veg_total)*100, digits = 2))
colnames(tabela) <- c("Vegetação natural", "Agropecuária", "Outros")
rownames(tabela) <- c("Percentual")
print(tabela)

