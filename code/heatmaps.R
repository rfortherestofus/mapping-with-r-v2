library(tidyverse)
library(sf)

traffic_signals <-
  read_csv("data/portland-traffic-signals.csv") |>
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326
  )

traffic_signals |>
  mapview::mapview()

traffic_signals_grid <-
  traffic_signals |>
  st_make_grid(
    n = c(100, 100),
    square = FALSE
  ) |>
  st_as_sf() |>
  mutate(grid_id = row_number())

ggplot() +
  geom_sf(data = traffic_signals) +
  geom_sf(data = traffic_signals_grid, alpha = 0.2)

traffic_signals_grid_count <-
  traffic_signals_grid |>
  st_join(traffic_signals) |>
  count(grid_id)

ggplot() +
  # geom_sf(data = traffic_signals,
  #         alpha = 0.5) +
  geom_sf(
    data = traffic_signals_grid_count,
    aes(fill = n),
    alpha = 0.8
  )
