library(tidyverse)
library(sf)

portland_corners_csv <-
  read_csv("data/portland_corners.csv")

portland_corners_csv

portland_corners_sf <-
  portland_corners_csv |>
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326
  )

portland_corners_sf

portland_corners_sf |>
  mapview::mapview()

