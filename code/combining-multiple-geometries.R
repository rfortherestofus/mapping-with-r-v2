library(sf)
library(tidyverse)
library(scales)

city_council_districts <-
  read_sf("data/portland_city_council_districts.geojson")

city_council_districts |>
  mapview::mapview()

improved_corners_by_district <-
  read_sf("data/improved_corners_by_district.geojson")

improved_corners_by_area <-
  improved_corners_by_district |>
  mutate(area = case_when(
    district == "District 4" ~ "Westside",
    .default = "Eastside"
  )) |>
  group_by(area, ramp_style) |>
  summarize(n = sum(n)) |>
  ungroup() |>
  group_by(area) |>
  mutate(pct = n / sum(n)) |>
  ungroup()

improved_corners_by_area |> 
  filter(ramp_style == "Improved") |> 
  ggplot() +
  geom_sf(aes(fill = pct)) +
  labs(fill = NULL) +
  scale_fill_viridis_c(
    option = "B",
    limits = c(0.25, 0.35),
    labels = percent_format(accuracy = 1)
  ) +
  theme_void() +
  theme(
    legend.position = "top",
    legend.key.width = unit(2, "cm"),
    legend.key.height = unit(0.5, "cm")
  )
