library(tidyverse)
library(tidygeocoder)

some_addresses <- tribble(
  ~name,
  ~addr,
  "White House",
  "1600 Pennsylvania Ave NW, Washington, DC",
  "Transamerica Pyramid",
  "600 Montgomery St, San Francisco, CA 94111",
  "Willis Tower",
  "233 S Wacker Dr, Chicago, IL 60606"
)

fp <- "https://urban-data-catalog.s3.amazonaws.com/drupal-root-live/2020/02/25/geocoding_test_data.csv"

to_geocode <- readr::read_csv(
  fp,
  readr::locale(encoding = "UTF-8"),
  skip = 1
)

geocoded <-
  to_geocode |>
  mutate(X1 = str_conv(X1, encoding = "UTF-8")) |>
  geocode(
    X1,
    method = "arcgis"
  )

geocoded

some_addresses |>
  select(addr) |>
  add_row(addr = "Eiffel Tower") |>
  geocode(
    addr,
    method = "arcgis"
  ) |>
  st_as_sf(
    coords = c("long", "lat"),
    crs = 4326
  ) |>
  mapview::mapview()
