library(leaflet)
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)
library(sf)


speak_language_other_than_english_wgs84_with_labels <-
  read_sf("data/speak_language_other_than_english_wgs84_with_labels.geojson")


speak_language_other_than_english_wgs84_with_labels


pal <-
  colorNumeric(
    palette = "viridis",
    domain = speak_language_other_than_english_wgs84_with_labels$pct
  )

leaflet() |>
  setView(-93.65, 42.0285, zoom = 2) |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84_with_labels,
    fillColor = ~ pal(pct),
    color = "white",
    weight = 0.75,
    popup = ~text_label
  )


binpal <-
  colorBin(
    palette = "viridis",
    domain = speak_language_other_than_english_wgs84_with_labels$pct,
    bins = 4
  )

leaflet() |>
  setView(-93.65, 42.0285, zoom = 2) |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84_with_labels,
    fillColor = ~ binpal(pct),
    color = "white",
    weight = 0.75,
    popup = ~text_label
  )


binpal_explicit_bins <-
  colorBin(
    palette = "viridis",
    domain = speak_language_other_than_english_wgs84_with_labels$pct,
    bins = c(0, 0.25, 0.5, 0.75, 1)
  )

leaflet() |>
  setView(-93.65, 42.0285, zoom = 2) |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84_with_labels,
    fillColor = ~ binpal_explicit_bins(pct),
    color = "white",
    weight = 0.75,
    popup = ~text_label
  )


leaflet() |>
  setView(-93.65, 42.0285, zoom = 2) |>
  addProviderTiles("CartoDB.Positron") |>
  addPolygons(
    data = speak_language_other_than_english_wgs84_with_labels,
    fillColor = ~ binpal_explicit_bins(pct),
    color = "white",
    weight = 0.75,
    popup = ~text_label
  ) |>
  addLegend(
    position = "bottomright",
    pal = binpal_explicit_bins,
    values = speak_language_other_than_english_wgs84_with_labels$pct,
    labFormat = labelFormat(
      transform = function(x) x * 100,
      suffix = "%"
    ),
    opacity = 0.5
  )

