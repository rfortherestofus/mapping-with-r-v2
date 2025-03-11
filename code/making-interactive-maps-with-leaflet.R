options(tigris_use_cache = TRUE)


library(leaflet)
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)
library(sf)


speak_language_other_than_english <-
  get_acs(
    geography = "county",
    variable = "S1601_C01_003",
    summary_var = "S1601_C01_001",
    geometry = TRUE
  ) |>
  clean_names() |>
  mutate(pct = estimate / summary_est) |>
  select(name, pct)


# speak_language_other_than_english |>
#   mapview::mapview()


leaflet() |>
  addTiles() |>
  addMarkers(lng = 174.768, lat = -36.852, popup = "The birthplace of R")


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addMarkers(lng = 174.768, lat = -36.852, popup = "The birthplace of R")


leaflet() |>
  addProviderTiles("Stadia.StamenToner") |>
  addMarkers(lng = 174.768, lat = -36.852, popup = "The birthplace of R")


speak_language_other_than_english_wgs84 <-
  speak_language_other_than_english |>
  st_transform(crs = 4326)


# speak_language_other_than_english_wgs84 |>
#   write_sf("data/speak_language_other_than_english_wgs84.geojson")


leaflet() |>
  addTiles() |>
  addPolygons(data = speak_language_other_than_english_wgs84)


leaflet() |>
  addTiles() |>
  addPolygons(
    data = speak_language_other_than_english_wgs84,
    weight = 0
  )


leaflet() |>
  addTiles() |>
  addPolygons(
    data = speak_language_other_than_english_wgs84,
    weight = 1,
    color = "red"
  )


portland_drinking_fountains <-
  read_sf("data/drinking_fountains.geojson"")


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addCircles(data = portland_drinking_fountains)


library(tigris)

multnomah_county_roads <-
  roads(state = "OR", county = "Multnomah")


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addPolylines(data = multnomah_county_roads)


leaflet() |>
  addProviderTiles("CartoDB.Positron", group = "Map") |>
  addProviderTiles("Esri.WorldImagery", group = "Satellite") |>
  addCircles(
    data = portland_drinking_fountains,
    group = "Drinking Fountains",
    color = "green"
  ) |>
  addPolylines(
    data = multnomah_county_roads,
    group = "Roads",
    weight = 1,
    color = "purple"
  ) |>
  addLayersControl(,
    baseGroups = c(
      "Map",
      "Satellite"
    ),
    overlayGroups = c(
      "Roads",
      "Drinking Fountains"
    )
  ) |>
  hideGroup("Roads")

