library(rnaturalearth)

ne_countries()

library(tidyverse)

ne_countries() |>
  ggplot() +
  geom_sf()

library(mapview)

ne_countries() |>
  mapview()

