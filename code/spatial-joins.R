
# # library(sf)
# # library(tidyverse)
# # library(janitor)
# 
# # corners_improved <-
# #   read_sf("data/https://hub.arcgis.com/api/v3/datasets/2110697e9c1e42f3a87f75c310da64f1_78/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1") |>
# #   clean_names() |>
# #   # Turn shapes into points for simplicity
# #   st_point_on_surface() |>
# #   select(objectid, ramp_style)
# 
# # fs::file_delete("data/improved_corners.geojson")
# 
# # corners_improved |>
# #   mutate(
# #     ramp_style = case_when(
# #       ramp_style %in% c("NONE", "UNKNOWN") ~ "Unimproved",
# #       .default = "Improved"
# #     )
# #   ) |>
# #   write_sf("data/improved_corners.geojson")


library(sf)

improved_corners <-
  read_sf("data/improved_corners.geojson")

improved_corners


# library(mapview)
# 
# improved_corners |>
#   mapview(zcol = "ramp_style")


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



# st_join(
#   city_council_districts,
#   improved_corners
# ) |>
#   count(district, ramp_style)



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



# improved_corners_by_district |>
#   write_sf("data/improved_corners_by_district.geojson")


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


# read_sf(
#   "https://hub.arcgis.com/api/v3/datasets/418ceb86c89b45a39ac0e27bc2722393_233/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1"
# ) |>
#   clean_names() |>
#   select(sextant) |>
#   write_sf("data/portland_sextants.geojson")

