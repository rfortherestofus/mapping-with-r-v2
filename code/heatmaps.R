library(sf)
library(tidyverse)
library(janitor)
library(scales)

improved_corners <-
  read_sf("data/improved_corners.geojson")

improved_corners

portland_boundaries <-
  read_sf("data/portland_boundaries.geojson")

portland_grid <-
  portland_boundaries |>
  st_make_grid(n = c(100, 100))

ggplot() +
  geom_sf(data = portland_boundaries) +
  geom_sf(
    data = portland_grid,
    alpha = 0.5
  )

portland_grid_map <-
  st_intersection(
    portland_boundaries,
    portland_grid
  ) |>
  mutate(grid_id = row_number()) |>
  select(grid_id)

portland_grid_map

portland_grid_map |>
  ggplot() +
  geom_sf()

improved_corners_grid <-
  st_join(
    portland_grid_map,
    improved_corners
  )

unimproved_corners_grid_pct <-
  improved_corners_grid |>
  st_drop_geometry() |>
  count(grid_id, ramp_style) |>
  complete(grid_id, ramp_style) |>
  group_by(grid_id) |>
  mutate(pct = n / sum(n, na.rm = TRUE)) |>
  ungroup() |>
  select(-n) |>
  pivot_wider(
    id_cols = grid_id,
    names_from = ramp_style,
    values_from = pct
  ) |>
  mutate(pct = case_when(
    is.na(Unimproved) & Improved == 1 ~ 0,
    .default = Unimproved
  )) |>
  select(grid_id, pct) |>
  left_join(
    portland_grid_map,
    join_by(grid_id)
  ) |>
  st_as_sf()

unimproved_corners <-
  improved_corners |>
  filter(ramp_style == "Unimproved")

only_improved_corners <-
  improved_corners |>
  filter(ramp_style == "Improved")

ggplot() +
  geom_sf(data = portland_boundaries) +
  geom_sf(
    data = unimproved_corners_grid_pct,
    aes(fill = pct),
    color = "white"
  ) +
  # geom_sf(
  #   data = improved_corners,
  #   aes(color = ramp_style),
  #   alpha = 0.5
  # ) +
  labs(fill = NULL, title = "Percentage of unimproved corners in Portland") +
  scale_fill_viridis_c(
    option = "E",
    na.value = "gray90",
    limits = c(0, 1),
    labels = percent_format()
  ) +
  theme_void() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      margin = margin(b = 10, unit = "pt")
    ),
    legend.key.width = unit(1.5, "cm"),
    legend.key.height = unit(0.5, "cm"),
    legend.position = "top"
  )
