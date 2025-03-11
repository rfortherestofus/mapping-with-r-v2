library(sf)
library(tidyverse)

improved_corners_by_district <-
  read_sf("data/improved_corners_by_district.geojson")


improved_corners_by_area <-
  improved_corners_by_district |>
  mutate(
    area = case_when(
      district == "District 4" ~ "Westside",
      .default = "Eastside"
    )
  ) |>
  group_by(area, ramp_style) |>
  summarize(n = sum(n)) |>
  group_by(area) |>
  mutate(pct = n / sum(n)) |>
  ungroup()

improved_corners_by_area



# library(mapview)
# 
# mapview(
#   improved_corners_by_area,
#   zcol = "area"
# )


library(scales)

improved_corners_by_area |>
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

