library(leaflet)
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)
library(sf)
library(mapgl)

mapboxgl(style = mapbox_style("light"))

mapboxgl(style = mapbox_style("dark"))

mapboxgl(style = mapbox_style("outdoors"))

maplibre()

maplibre(style = carto_style("positron"))

maplibre(style = carto_style("dark-matter"))

mapboxgl(
  mapbox_style("light"),
  center = c(-43.23412, -22.91370)
)

mapboxgl(
  mapbox_style("light"),
  center = c(-43.23412, -22.91370),
  zoom = 5
)

speak_language_other_than_english_wgs84_with_labels <-
  read_sf("data/speak_language_other_than_english_wgs84_with_labels.geojson")

mapboxgl(
  mapbox_style("light"),
  center = c(-100.29957845401096, 38.93484429077689),
  zoom = 2
) |>
  add_fill_layer(
    id = "speak_language_other_than_english_wgs84_with_labels",
    source = speak_language_other_than_english_wgs84_with_labels
  )

mapboxgl(
  mapbox_style("light"),
  center = c(-100.29957845401096, 38.93484429077689),
  zoom = 2
) |>
  add_fill_layer(
    id = "speak_language_other_than_english_wgs84_with_labels",
    source = speak_language_other_than_english_wgs84_with_labels,
    fill_color = interpolate(
      column = "pct",
      values = c(0, 1),
      stops = c("lightblue", "darkblue"),
      na_color = "lightgrey"
    ),
    fill_opacity = 1
  )

mapboxgl(
  mapbox_style("light"),
  center = c(-100.29957845401096, 38.93484429077689),
  zoom = 2
) |>
  add_fill_layer(
    id = "speak_language_other_than_english_wgs84_with_labels",
    source = speak_language_other_than_english_wgs84_with_labels,
    fill_color = interpolate(
      column = "pct",
      values = c(0, 1),
      stops = c("lightblue", "darkblue"),
      na_color = "lightgrey"
    ),
    popup = "text_label",
    fill_opacity = 1
  )

mapboxgl() |>
  fly_to(
    center = c(2.1228412549747344, 41.3812461533571),
    zoom = 16,
    pitch = 25
  )

