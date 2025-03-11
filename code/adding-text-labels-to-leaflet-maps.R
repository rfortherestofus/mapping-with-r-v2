library(leaflet)
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)
library(sf)


speak_language_other_than_english_wgs84 <-
  read_sf("data/speak_language_other_than_english_wgs84.geojson")


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84,
    weight = 1
  )


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84,
    weight = 1,
    label = ~name
  )


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84,
    weight = 1,
    popup = ~name
  )


speak_language_other_than_english_wgs84_with_labels <-
  speak_language_other_than_english_wgs84 |>
  mutate(
    text_label = str_glue(
      "<b>{percent(pct, accuracy = 0.1)}</b> of the population of <b>{name}</b> speaks a language other than English"
    )
  )


leaflet() |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84_with_labels,
    weight = 1,
    popup = ~text_label
  )



# speak_language_other_than_english_wgs84_with_labels |>
#   select(name, pct, text_label) |>
#   write_sf("data/speak_language_other_than_english_wgs84_with_labels.geojson")

