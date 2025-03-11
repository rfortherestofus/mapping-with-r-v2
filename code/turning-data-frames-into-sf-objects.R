library(tidyverse)
library(sf)



# # https://www.portlandmaps.com/metadata/index.cfm?&action=DisplayLayer&LayerID=52777
# library(janitor)
# 
# portland_corners <-
#   read_sf(
#     "https://hub.arcgis.com/api/v3/datasets/2110697e9c1e42f3a87f75c310da64f1_78/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1"
#   ) |>
#   st_make_valid() |>
#   st_centroid()
# 
# portland_corners |>
#   clean_names() |>
#   select(asset_id, ramp_style) |>
#   st_coordinates() |>
#   as_tibble() |>
#   rename(longitude = X, latitude = Y) |>
#   write_csv("data/portland-corners.csv")


# library(sf)
# 
# csv_file |>
#   st_as_sf(
#     coords = c("x_variable", "y_variable"),
#     crs = 4326
#   )


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

