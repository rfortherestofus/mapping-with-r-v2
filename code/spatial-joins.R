
library(sf)

improved_corners <-
  read_sf("data/improved_corners.geojson")

improved_corners

city_council_districts <-
  read_sf("data/portland_city_council_districts.geojson")

city_council_districts

st_join(
  city_council_districts,
  improved_corners
)

st_join(
  improved_corners,
  city_council_districts
)

library(tidyverse)
library(janitor)

unimproved_corners_by_district <-
  st_join(
    improved_corners,
    city_council_districts
  ) |>
  filter(ramp_style == "Unimproved")

portland_boundaries <-
  read_sf("data/Portland_Boundaries.geojson") |>
  clean_names() |>
  filter(cityname == "Portland")

ggplot() +
  geom_sf(
    data = portland_boundaries,
    color = "transparent"
  ) +
  geom_sf(
    data = unimproved_corners_by_district
  ) +
  facet_wrap(vars(district)) +
  theme_void()

st_join(
  improved_corners,
  city_council_districts
) |>
  st_drop_geometry() |>
  count(district, ramp_style)

improved_corners_by_district <-
  st_join(
    improved_corners,
    city_council_districts
  ) |>
  st_drop_geometry() |>
  count(district, ramp_style) |>
  drop_na(district) |>
  group_by(district) |>
  mutate(pct = n / sum(n)) |>
  ungroup() |>
  left_join(city_council_districts, join_by(district)) |>
  st_as_sf()

improved_corners_by_district

library(scales)

improved_corners_by_district |>
  filter(ramp_style == "Unimproved") |>
  ggplot() +
  geom_sf(
    aes(fill = pct),
    color = "transparent"
  ) +
  labs(fill = NULL) +
  guides(
    fill = guide_colorsteps(show.limits = TRUE),
    color = guide_colorsteps(show.limits = TRUE),
  ) +
  scale_fill_viridis_c(
    option = "B",
    limits = c(0.65, 0.75),
    labels = percent_format(accuracy = 1)
  ) +
  theme_void() +
  theme(
    legend.position = "top",
    legend.key.width = unit(2, "cm"),
    legend.key.height = unit(0.5, "cm")
  )

