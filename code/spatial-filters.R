
# # library(sf)
# # library(janitor)
# 
# # read_sf("https://hub.arcgis.com/api/v3/datasets/2110697e9c1e42f3a87f75c310da64f1_78/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1") |>
# #   clean_names() |>
# #   st_make_valid() |>
# #   select(objectid, ramp_style) |>
# #   mutate(
# #     ramp_style = case_when(
# #       ramp_style %in% c("NONE", "UNKNOWN") ~ "Unimproved",
# #       .default = "Improved"
# #     )
# #   ) |>
# #   write_sf("data/improved_corners_polygons.geojson")


library(sf)
library(tidyverse)

improved_corners <-
  read_sf("data/improved_corners.geojson")

improved_corners


city_council_districts <-
  read_sf("data/city_council_districts.geojson")

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



# library(mapview)
# 
# mapview(improved_corners_polygons)


district_1_corners <-
  improved_corners_polygons |>
  st_filter(district_1_boundaries)

district_1_corners


# mapview(district_1_boundaries) +
#   mapview(district_1_corners)


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



# mapview(district_1_boundaries) +
#   mapview(district_1_corners_within)

