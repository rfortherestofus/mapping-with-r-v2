library(tidyverse)
library(tidycensus)
library(tigris)
library(janitor)
library(sf)


# oregon_places <-
#   get_decennial(
#     geography = "place",
#     state = "OR",
#     variables = "P1_001N",
#     geometry = TRUE,
#     year = 2020
#   ) |>
#   st_centroid() |>
#   select(NAME, value) |>
#   set_names("name", "population", "geometry")
# 
# oregon_places |>
#   write_sf("data/oregon_places.geojson")
# 
# oregon <-
#   states() |>
#   clean_names() |>
#   filter(name == "Oregon")


library(tidyverse)
library(tidycensus)
library(tigris)
library(janitor)
library(sf)


oregon <-
  states() |>
  clean_names() |>
  filter(name == "Oregon")

oregon_places <-
  read_sf("data/oregon_places.geojson")


oregon_places


ggplot() +
  geom_sf(data = oregon, fill = "transparent") +
  geom_sf(data = oregon_places) +
  theme_void()


ggplot() +
  geom_sf(data = oregon, fill = "transparent") +
  geom_sf(
    data = oregon_places,
    aes(size = population),
    alpha = 0.5
  ) +
  scale_size_continuous(range = c(1, 15)) +
  theme_void()


# acs_variables <-
#   load_variables(
#     year = 2023,
#     dataset = "acs5/subject",
#     cache = TRUE
#   )

# acs_variables |>
#   filter(str_detect(name, "S1601")) |>
#   filter(str_detect(label, "Estimate!!Total!!Population 5 years and over!!SPEAK A LANGUAGE OTHER THAN ENGLISH!!")) |>
#   mutate(langauge = str_remove(label, "!!Total!!Population 5 years and over!!SPEAK A LANGUAGE OTHER THAN ENGLISH!!")) |>
#   select(name, langauge, label)


languages_spoken <-
  get_acs(
    geography = "county",
    state = "OR",
    variable = c(
      spanish = "S1601_C01_004",
      other_indo_european = "S1601_C01_008",
      asian_pacific_islander = "S1601_C01_012",
      other = "S1601_C01_016"
    ),
    geometry = TRUE
  ) |>
  clean_names() |>
  select(variable, name, estimate)


languages_spoken


ggplot() +
  geom_sf(data = languages_spoken, aes(fill = estimate)) +
  scale_fill_viridis_c() +
  facet_wrap(vars(variable)) +
  theme_void()


languages_spoken_dots <-
  languages_spoken |>
  filter(name == "Washington County, Oregon") |>
  mutate(estimate = estimate / 100) |>
  as_dot_density(
    value = "estimate",
    values_per_dot = 1,
    group = "variable"
  )


languages_spoken_dots


ggplot() +
  geom_sf(data = languages_spoken_dots, aes(color = variable)) +
  geom_sf(
    data = languages_spoken |>
      filter(name == "Washington County, Oregon"),
    fill = "transparent"
  ) +
  theme_void()


ggplot() +
  geom_sf(data = languages_spoken_dots, aes(color = variable)) +
  geom_sf(
    data = languages_spoken |>
      filter(name == "Washington County, Oregon"),
    fill = "transparent"
  ) +
  theme_void() +
  facet_wrap(vars(variable))


read_sf(
  "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/refugees.geojson"
) |>
  st_point_on_surface() |>
  write_sf("data/refugees_country_centroids.geojson")


refugees_by_country <-
  read_sf(
    "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/refugees.geojson"
  )


refugees_country_centroids <-
  read_sf(
    "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/refugees_country_centroids.geojson"
  )


# ggplot() +
#   geom_sf(data = refugees_by_country) +
#   geom_sf(data = refugees_country_centroids, aes(size = number_of_refugees))

