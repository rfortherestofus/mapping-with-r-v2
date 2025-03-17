library(tidyverse)

city_councilors <-
  read_csv("data/portland_city_councilors.csv")

city_councilors

library(sf)

city_council_districts <-
  read_sf("data/portland_city_council_districts.geojson")

city_council_districts

library(mapview)

city_council_districts |>
  mapview()

left_join(
  city_councilors,
  city_council_districts,
  join_by(district)
)

left_join(
  city_councilors,
  city_council_districts,
  join_by(district)
) |>
  st_as_sf()

left_join(
  city_councilors,
  city_council_districts,
  join_by(district)
) |>
  st_as_sf()

right_join(
  city_councilors,
  city_council_districts,
  join_by(district)
) |>
  st_as_sf()

