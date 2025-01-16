# Rhode Island -----------------------------------------------------------



# Oregon cities ----------------------------------------------------------

library(tigris)
library(tidyverse)
library(janitor)

places(state = "OR") |>
  clean_names() |>
  select(name, intptlat, intptlon) |>
  st_drop_geometry() |>
  as_tibble() |>
  set_names(c("place", "latitude", "longitude")) |>
  mutate(latitude = parse_number(latitude)) |>
  mutate(longitude = parse_number(longitude)) |>
  write_csv("data/oregon-towns.csv")


# Portland traffic signals -----------------------------------------------

library(sf)

traffic_signal_numbers <-
  read_sf("data/Traffic_Signals.geojson") |>
  st_drop_geometry() |>
  clean_names() |>
  select(signal_num) |>
  set_names("signal_number")

read_sf("data/Traffic_Signals.geojson") |>
  clean_names() |>
  select(signal_num) |>
  st_coordinates() |>
  as_tibble() |>
  set_names(c("longitude", "latitude")) |>
  bind_cols(traffic_signal_numbers) |>
  select(signal_number, longitude, latitude) |>
  write_csv("data/portland-traffic-signals.csv")
