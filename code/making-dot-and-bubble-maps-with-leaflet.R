options(tigris_use_cache = TRUE)


library(leaflet)
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)
library(sf)
library(leaflegend)


portland_drinking_fountains <-
  read_sf("data/drinking_fountains.geojson")


portland_drinking_fountains |>
  st_drop_geometry() |>
  count(FOUNTAINSTYLE)


pal_discrete <- colorFactor(
  palette = c(
    "#7fc97f",
    "#beaed4",
    "#fdc086",
    "#ffff99",
    "#386cb0",
    "#f0027f"
  ),
  na.color = "gray70",
  domain = fct(portland_drinking_fountains$FOUNTAINSTYLE)
)


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addCircles(
    data = portland_drinking_fountains,
    stroke = FALSE,
    fillColor = ~ pal_discrete(FOUNTAINSTYLE),
    radius = 10,
    fillOpacity = 1
  )


oregon_places <-
  read_sf("data/oregon_places.geojson") |>
  st_transform(crs = 4326)


oregon_places


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addCircles(
    data = oregon_places,
    radius = ~ population / 100,
    label = ~name,
    stroke = FALSE,
    fillOpacity = 0.5
  ) |>
  addLegendSize(
    values = c(0, 500000),
    color = "blue",
    shape = "circle",
    opacity = .5,
    breaks = 10
  )


refugees_country_centroids <-
  read_sf(
    "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/refugees_country_centroids.geojson"
  )

