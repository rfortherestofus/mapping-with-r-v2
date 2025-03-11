library(tidyverse)
library(rnaturalearth)

all_countries <-
  ne_countries() |>
  select(sovereignt)


all_countries



library(sf)

all_countries |>
  ggplot() +
  geom_sf()


all_countries |>
  st_transform(
    "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
  ) |>
  ggplot() +
  geom_sf()


all_countries |>
  st_transform(
    "+proj=cea +lon_0=0 +lat_ts=45 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
  ) |>
  ggplot() +
  geom_sf()


all_countries |>
  st_transform("+proj=moll +datum=WGS84 +units=m") |>
  ggplot() +
  geom_sf()


all_countries |>
  st_transform("+proj=laea +x_0=0 +y_0=0 +lon_0=0 +lat_0=0") |>
  ggplot() +
  geom_sf()


library(crsuggest)

africa <-
  ne_countries(continent = "Africa") |>
  select(sovereignt)

africa |>
  ggplot() +
  geom_sf()


africa |>
  suggest_top_crs()


africa_crs <-
  africa |>
  suggest_top_crs()



africa |>
  st_transform(africa_crs) |>
  ggplot() +
  geom_sf()


africa |>
  ggplot() +
  geom_sf()


africa |>
  st_transform(africa_crs) |>
  ggplot() +
  geom_sf()


library(tigris)

continental_us_states <-
  states() |>
  select(NAME) |>
  filter(NAME %in% state.name) |>
  filter(NAME != "Alaska") |>
  filter(NAME != "Hawaii")


continental_us_states |>
  ggplot() +
  geom_sf()


us_crs <-
  continental_us_states |>
  suggest_top_crs()

continental_us_states |>
  st_transform(us_crs) |>
  ggplot() +
  geom_sf()

