library(tidyverse)
library(sf)

read_csv("data/portland-traffic-signals.csv") |>
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326
  ) |>
  mapview::mapview()
