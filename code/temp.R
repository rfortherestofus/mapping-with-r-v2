library(sf)
library(tidyverse)

pdx_councils <-
  read_sf("data/export-8790.geojson") |>
    group_by(districtr) |>
    summarize()

pdx_councils |>
  mapview::mapview()

library(mapboxapi)

vector_extract <- get_vector_tiles(
  tileset_id = "mapbox.mapbox-streets-v8",
  location = c(-73.99405, 40.72033),
  zoom = 15
)

names(vector_extract)

library(ggplot2)

ggplot(vector_extract$building$polygons) +
  geom_sf() +
  geom_sf(data = vector_extract$poi_label) +
  theme_void()
