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

inflow_origins <-
  inflow |>
  st_drop_geometry() |>
  select(geoid2, full2_name, estimate, centroid2) |>
  st_set_geometry("centroid2")

inflow_origins |>
  mapview::mapview()

inflow_origins_centroids <-
  inflow_origins |>
  st_coordinates("centroid2") |>
  as_tibble() |>
  set_names("origin_x", "origin_y")

inflow_desination <-
  inflow |>
  select(geoid1, full1_name, estimate)

inflow_desination_centroid <-
  inflow_desination |>
  st_coordinates("centroid1") |>
  as_tibble() |>
  set_names("desination_x", "desination_y")

inflow_x_y <-
  inflow_origins_centroids |>
  bind_cols(inflow_desination_centroid)

origin_states <-
  inflow |>
  st_drop_geometry() |>
  select(full2_name) |>
  separate_wider_delim(
    full2_name,
    delim = ", ",
    names = c("county", "state")
  ) |>
  distinct(state) |>
  pull(state)

origin_states_sf <-
  states() |>
  clean_names() |>
  select(name) |>
  filter(name %in% origin_states)

ggplot() +
  geom_sf(data = origin_states_sf) +
  geom_curve(
    data = inflow_x_y,
    aes(
      x = origin_x,
      xend = desination_x,
      y = origin_y,
      yend = desination_y
    )
  ) +
  geom_sf(data = inflow_origins) +
  geom_sf(data = inflow_desination,
          color = "orange") +
  theme_void()
