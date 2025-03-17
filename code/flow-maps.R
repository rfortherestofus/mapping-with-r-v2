library(tidyverse)
library(tidycensus)
library(tigris)
library(janitor)
library(sf)

inflow <-
  get_flows(
    geography = "county",
    state = "OR",
    county = "Deschutes",
    geometry = TRUE
  ) |>
  clean_names() |>
  filter(variable == "MOVEDIN") |>
  slice_max(order_by = estimate, n = 10) |>
  drop_na(geoid2) # To get rid of Asia

inflow

inflow_origins <-
  inflow |>
  st_drop_geometry() |>
  st_set_geometry("centroid2") |>
  select(geoid2, full2_name, estimate)

inflow_origins

inflow_origins_centroid <-
  inflow |>
  select(centroid1, centroid2) |>
  st_drop_geometry() |>
  st_set_geometry("centroid2") |>
  st_coordinates(centroid2) |>
  as_tibble() |>
  set_names("origin_x", "origin_y")

inflow_origins_centroid

inflow_destination_centroid <-
  inflow |>
  select(geoid1, full1_name, estimate) |>
  st_coordinates() |>
  as_tibble() |>
  set_names("destination_x", "destination_y")

inflow_destination_centroid

inflow_x_y <-
  inflow |>
  select(estimate) |>
  st_drop_geometry() |>
  bind_cols(inflow_origins_centroid) |>
  bind_cols(inflow_destination_centroid)

inflow_x_y

origin_states <-
  inflow_origins |>
  st_drop_geometry() |>
  separate_wider_delim(
    full2_name,
    delim = ", ",
    names = c("county", "state")
  ) |>
  distinct(state) |>
  pull(state)

origin_states

origin_states_sf <-
  states(progress_bar = FALSE) |>
  clean_names() |>
  select(name) |>
  filter(name %in% origin_states)

origin_states_sf

ggplot() +
  geom_sf(data = origin_states_sf, fill = "transparent") +
  geom_curve(
    data = inflow_x_y,
    aes(
      x = origin_x,
      xend = destination_x,
      y = origin_y,
      yend = destination_y
    ),
    color = "orange"
  ) +
  geom_sf(
    data = inflow,
    shape = 21,
    size = 3,
    fill = "white"
  ) +
  geom_sf(
    data = inflow_origins
  ) +
  scale_size_continuous(range = c(0.5, 2)) +
  scale_linewidth_continuous(range = c(0.5, 2)) +
  theme_void()

countries <-
  read_sf(
    "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/countries.geojson"
  )

