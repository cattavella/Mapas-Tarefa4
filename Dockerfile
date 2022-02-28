
FROM rocker/tidyverse

WORKDIR "./Mapas-Tarefa4"

RUN R -e "install.packages('pacman')"
RUN R -e "install.packages('sf')"
RUN R -e "install.packages('hrbrthemes')"
RUN R -e "install.packages('lwgeom')"
RUN R -e "install.packages('rnaturalearth')"
RUN R -e "install.packages('maps')"
RUN R -e "install.packages('mapdata')"
RUN R -e "install.packages('terra')"
RUN R -e "install.packages('spData')"
RUN R -e "install.packages('tigris')"
RUN R -e "install.packages('leaflet')"
RUN R -e "install.packages('mapview')"
RUN R -e "install.packages('tmap')"
RUN R -e "install.packages('raster')"
RUN R -e "install.packages('geobr')"


COPY "./Tarefa4-DF.R"			"./Tarefa4-DF.R"

CMD Rscript "./Tarefa4-DF.R"


