library(sf)
library(tidyverse)

pdx_councils <- 
  read_sf("data/export-8790.geojson") |> 
  group_by(districtr) |> 
  summarize()

pdx_councils |> 
  mapview::mapview()
