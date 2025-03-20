library(tidyverse)

# Read the file, make the replacement, and write it back
read_lines("code/scratch.R") |>
  str_replace_all(
    pattern = 'read_sf\\("data/',
    replacement = 'read_sf\\("https://raw.githubusercontent.com/rfortherestofus/mapping-with-r-v2/refs/heads/main/data/'
  ) |>
  write_lines("code/scratch.R")
