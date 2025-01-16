
# Load packages ----------------------------------------------------------

library(sf)

# Download data ----------------------------------------------------------

# https://public.opendatasoft.com/explore/dataset/world-administrative-boundaries-countries/information/


# ESRI shapefiles --------------------------------------------------------

read_sf("data/world-administrative-boundaries-countries/world-administrative-boundaries-countries.shp")

# GeoJSON ----------------------------------------------------------------

read_sf("data/world-administrative-boundaries-countries.geojson")
