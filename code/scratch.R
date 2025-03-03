library(sf)
library(tidyverse)
library(tidycensus)
library(janitor)

corners_improved <-
  read_sf("data/Corners_Improved.geojson") |>
  clean_names() |>
  clean_names() |>
  st_point_on_surface() |>
  select(objectid, ramp_style)

corners_improved |>
  mutate(
    ramp_style_dichotomous = case_when(
      ramp_style %in% c("NONE", "UNKNOWN") ~ "Unimproved",
      .default = "Improved"
    )
  ) |>
  write_sf("data/improved_corners.geojson")

# city_council_districts <-
read_sf("data/Portland_City_Council_Districts.geojson") |>
  clean_names() |>
  select(district) |>
  mutate(district = str_glue("District {district}")) |>
  write_sf("data/city_council_districts.geojson")

city_council_districts <-
  read_sf("data/city_council_districts.geojson")

city_councilors <-
  tibble::tribble(
    ~councilor,
    ~district,
    "Candace Avalos",
    "District 1",
    "Jamie Dunphy",
    "District 1",
    "Loretta Smith",
    "District 1",
    "Dan Ryan",
    "District 2",
    "Elana Pirtle-Guiney",
    "District 2",
    "Sameer Kanal",
    "District 2",
    "Angelita Morillo",
    "District 3",
    "Steve Novick",
    "District 3",
    "Tiffany Koyama Lane",
    "District 3",
    "Eric Zimmerman",
    "District 4",
    "Mitch Green",
    "District 4",
    "Olivia Clark",
    "District 4"
  )

city_councilors |>
  write_csv("data/city_councilors.csv")


corners_improved |>
  mapview::mapview()

# median_household_income <-
#   get_acs(
#     geography = "tract",
#     state = "OR",
#     variable = "B19013_001",
#     geometry = TRUE
#   ) |>
#   clean_names() |>
#   select(geoid, estimate) |>
#   st_transform(4326)

st_join(
  city_council_districts,
  corners_improved
) |>
  select(district, objectid, ramp_style) |>
  st_drop_geometry() |>
  count(ramp_style)


# remotes::install_gitlab("dickoa/rgeoboundaries")
library(rgeoboundaries)
library(sf)
library(tidyverse)


geoboundaries(
  country = c("Ukraine", "Russia"),
  type = "hpscu",
) |>
  ggplot() +
  geom_sf()

# mapgl ------------------------------------------------------------------

library(mapgl)

mapboxgl(
  style = mapbox_style("standard-satellite"),
  center = mb_geocode("4031 NE 23rd Avenue Portland, OR 97212"),
  zoom = 14,
  pitch = 80,
  bearing = 0
) |>
  add_raster_dem_source(
    id = "mapbox-dem",
    url = "mapbox://mapbox.mapbox-terrain-dem-v1",
    tileSize = 512,
    maxzoom = 14
  ) |>
  set_terrain(
    source = "mapbox-dem",
    exaggeration = 5
  )

install.packages("mapboxapi")

library(mapboxapi)


# Heatmap with ggplot ----------------------------------------------------

library(tidyverse)
library(sf) # for handling spatial data
library(tigris) # for US geographic data (optional)

# Example using US state-level data
# First get the spatial data and join it with your data

# Here's a complete example:
states_sf <- tigris::states() |>
  st_transform(4326) # Convert to standard lat/long projection

# Example data - let's say you have state-level values
state_data <- tibble(
  NAME = state.name,
  # built-in R vector of state names
  value = rnorm(length(state.name)) # random values for demonstration
)

# Join spatial data with your values
states_with_data <- states_sf |>
  left_join(state_data, by = "NAME")

# Create the map
ggplot(states_with_data) +
  geom_sf(aes(fill = value)) +
  scale_fill_viridis_c() +
  theme_minimal() +
  labs(
    title = "US State Heatmap",
    fill = "Value"
  )

library(tidyverse)
library(sf)
library(gstat) # for interpolation
library(stars) # for raster operations

point_data <- tibble(
  longitude = runif(1000, -125, -65),
  # random US longitudes
  latitude = runif(1000, 25, 50),
  # random US latitudes
  value = rnorm(1000) # random values
)

# Assuming you have point data
points_sf <- point_data |>
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# Create a regular grid for interpolation
grid <- points_sf |>
  st_bbox() |>
  st_as_stars(dx = 0.5) |> # adjust resolution as needed
  st_as_sf()

# Interpolate values
idw <- gstat::idw(value ~ 1, points_sf, grid)

# Plot the interpolated surface
ggplot() +
  geom_sf(data = states_sf, fill = "transparent") +
  geom_sf(data = idw, aes(fill = var1.pred)) +
  scale_fill_viridis_c() +
  theme_minimal() +
  labs(
    title = "Interpolated Geographic Heatmap",
    fill = "Value"
  )

library(tidyverse)
library(sf)
library(rnaturalearth)

world <- ne_countries(scale = "medium", returnclass = "sf")

world_6933 <- st_transform(world, 6933)
world_grid_6933 <- st_make_grid(
  world_6933,
  n = c(100, 100),
  what = "polygons",
  square = FALSE,
  flat_topped = TRUE
) %>%
  st_as_sf() %>%
  mutate(area = st_area(.))

world_grid_6933 |>
  ggplot() +
  geom_sf(aes(fill = units::drop_units(area)))

p2 <- ggplot() +
  geom_sf(
    data = world_grid_6933,
    aes(fill = units::drop_units(area))
  ) +
  geom_sf(
    data = world_6933,
    fill = NA,
    color = "white"
  )

cowplot::plot_grid(
  p1,
  p2,
  nrow = 2,
  labels = c("unequal hexagons", "equal hexagons")
)
