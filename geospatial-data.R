library(sf)


# ESRI shapefiles --------------------------------------------------------

# https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2024&layergroup=States+(and+equivalent)

read_sf("data/tl_2024_us_state/tl_2024_us_state.shp")


# GeoJSON ----------------------------------------------------------------

# https://github.com/PublicaMundi/MappingAPI/blob/master/data/geojson/us-states.json

read_sf("data/us-states.json")
