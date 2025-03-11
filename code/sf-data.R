library(sf)
library(tidyverse)

wyoming <-
  read_sf("data/wyoming.geojson")

wyoming


ggplot() +
  geom_sf(data = wyoming)


wyoming_one_ev_station <-
  read_sf("data/wyoming-one-ev-station.geojson")

wyoming_one_ev_station


ggplot() +
  geom_sf(data = wyoming) +
  geom_sf(data = wyoming_one_ev_station)


wyoming_highway_30 <-
  read_sf("data/wyoming-highway-30.geojson")

wyoming_highway_30


ggplot() +
  geom_sf(data = wyoming) +
  geom_sf(data = wyoming_highway_30)


# fs::file_delete("data/rhode-island.geojson")
#
# read_sf("data/BND_State_1997_spf_-1467871017424358584.geojson") |>
#   summarize(geometry = st_combine(geometry)) |>
#   write_sf(
#     "data/rhode-island.geojson"
#   )

rhode_island <-
  read_sf("data/rhode-island.geojson")

rhode_island


ggplot() +
  geom_sf(data = rhode_island)


wyoming_all_ev_stations <-
  read_sf("data/wyoming-all-ev-stations.geojson")

wyoming_all_ev_stations


ggplot() +
  geom_sf(data = wyoming) +
  geom_sf(data = wyoming_all_ev_stations)


wyoming_roads <-
  read_sf("data/wyoming-roads.geojson")

wyoming_roads


ggplot() +
  geom_sf(data = wyoming) +
  geom_sf(data = wyoming_roads)


wyoming


rhode_island


rhode_island_bounding_box <-
  rhode_island |>
  st_bbox() |>
  st_as_sfc() |>
  st_sf() |>
  rename(geometry = st_as_sfc.st_bbox.rhode_island..)


rhode_island_bounding_box


ggplot() +
  geom_sf(data = rhode_island) +
  geom_sf(
    data = rhode_island_bounding_box,
    color = "red",
    linewidth = 1,
    fill = NA
  )


wyoming


wyoming_different_projection <-
  wyoming |>
  st_transform(5070)


wyoming_different_projection


wyoming |>
  ggplot() +
  geom_sf()


wyoming_different_projection |>
  ggplot() +
  geom_sf()


wyoming


wyoming_coordinates <-
  wyoming |>
  st_coordinates() |>
  as_tibble() |>
  rename(longitude = X, latitude = Y) |>
  select(longitude, latitude)


wyoming_coordinates


wyoming_coordinates |>
  ggplot(
    aes(
      x = longitude,
      y = latitude
    )
  ) +
  geom_point()

# library(gganimate)
#
# wyoming_coordinates_animated <-
#   wyoming_coordinates |>
#   mutate(row_number = row_number()) |>
#   # slice(1:10) |>
#   ggplot(
#     aes(
#       x = longitude,
#       y = latitude,
#       group = row_number
#     )
#   ) +
#   geom_point() +
#   transition_reveal(row_number)
#
# animate(
#   wyoming_coordinates_animated,
#   height = 4,
#   width = 6,
#   units = "in",
#   res = 300
# )
#
# anim_save("assets/wyoming-animated.gif")

# library(rnaturalearth)
# library(tidyverse)
# library(sf)
#
# ne_countries(continent = "Africa") |>
#   select(admin) |>
#   arrange(admin) |>
#   write_rds("data/africa.rds")

# library(tidyverse)
#
# africa <-
#   read_rds(
#     "https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/africa.rds"
#   )
