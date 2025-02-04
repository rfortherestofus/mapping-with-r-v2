# Asylum Seekers ---------------------------------------------------------

library(tidyverse)
library(refugees)
library(rnaturalearth)

countries_data <-
  ne_countries() |>
    select(iso_a3) |>
    rename(country_abbreviation = iso_a3) |>
    filter(country_abbreviation != "-99")

countries_data |>
  st_write("data/countries.geojson")

flows |>
  filter(year == 2023) |>
  filter(coa_name == "United States of America") |>
  select(coo_iso, asylum_seekers) |>
  slice_max(order_by = asylum_seekers, n = 5) |>
  rename(country_abbreviation = coo_iso) |>
  right_join(countries_data) |>
  drop_na(asylum_seekers) |>
  st_set_geometry("geometry") |>
  st_write("data/asylum_seekers.geojson")

# Refugees Data ----------------------------------------------------------

library(refugees)
library(rnaturalearth)
library(sf)

refugees <-
  population |>
    rename(country_abbreviation = coo_iso) |>
    group_by(year, country_abbreviation) |>
    summarise(number_of_refugees = sum(refugees, na.rm = TRUE)) |>
    ungroup() |>
    slice_max(order_by = year, n = 1) |>
    select(-year)

countries_data <-
  ne_countries() |>
    select(iso_a3) |>
    rename(country_abbreviation = iso_a3) |>
    filter(country_abbreviation != "-99")

countries_data |>
  right_join(refugees) |>
  st_write("data/refugees.geojson")

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
