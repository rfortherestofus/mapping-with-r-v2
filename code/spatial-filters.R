
library(sf)
library(tidyverse)

improved_corners <-
  read_sf("data/improved_corners.geojson")

improved_corners

city_council_districts <-
  read_sf("data/portland_city_council_districts.geojson")

city_council_districts

st_join(
  improved_corners,
  city_council_districts
) |>
  filter(district == "District 1")

district_1_boundaries <-
  city_council_districts |>
  filter(district == "District 1")

improved_corners |>
  st_filter(district_1_boundaries)

improved_corners_polygons <-
  read_sf("data/improved_corners_polygons.geojson")

improved_corners_polygons

district_1_corners <-
  improved_corners_polygons |>
  st_filter(district_1_boundaries)

district_1_corners

improved_corners_polygons |>
  st_filter(
    district_1_boundaries,
    .predicate = st_intersects
  )

improved_corners_polygons |>
  st_filter(
    district_1_boundaries,
    .predicate = st_within
  )

district_1_corners_within <-
  improved_corners_polygons |>
  st_filter(
    district_1_boundaries,
    .predicate = st_within
  )

district_1_corners_within

