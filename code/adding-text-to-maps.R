library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(scales)

speak_language_other_than_english <-
  get_acs(
    geography = "county",
    variable = "S1601_C01_003",
    summary_var = "S1601_C01_001",
    geometry = TRUE
  ) |>
  clean_names() |>
  mutate(pct = estimate / summary_est) |>
  select(name, pct)

languages_map <-
  speak_language_other_than_english |>
  shift_geometry() |>
  ggplot() +
  geom_sf(
    aes(
      fill = pct,
      color = pct
    )
  ) +
  guides(
    fill = guide_colorsteps(show.limits = TRUE),
    color = guide_colorsteps(show.limits = TRUE),
  ) +
  scale_fill_viridis_c(
    limits = c(0, 1),
    labels = percent_format()
  ) +
  scale_color_viridis_c(
    limits = c(0, 1),
    labels = percent_format()
  ) +
  labs(
    color = NULL,
    fill = NULL,
    title = "Percentage of People Who Speak a Language\nOther than English in Each County in the United States"
  ) +
  theme_void() +
  theme(
    legend.position = "top",
    legend.key.width = unit(2, "cm"),
    legend.key.height = unit(0.5, "cm"),
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 16,
      margin = margin(
        b = 0.25,
        unit = "cm"
      )
    )
  )


oregon_counties <-
  counties(state = "OR") |>
  clean_names()


oregon_counties


oregon_counties |>
  ggplot() +
  geom_sf() +
  geom_sf_text(aes(label = name))


languages_map


speak_language_other_than_english


languages_map +
  geom_sf_text(aes(label = name))


library(sf)

top_counties <-
  speak_language_other_than_english |>
  separate_wider_delim(name, delim = ", ", names = c("county", "state")) |>
  filter(state != "Puerto Rico") |>
  slice_max(order_by = pct, n = 5) |>
  mutate(map_label = str_glue("{county} ({percent(pct, accuracy = 1)})")) |>
  st_as_sf()


top_counties


languages_map +
  geom_sf_text(
    data = top_counties,
    aes(label = map_label)
  )


library(ggrepel)

languages_map +
  geom_text_repel(
    data = top_counties,
    aes(
      label = map_label,
      geometry = geometry
    ),
    stat = "sf_coordinates"
  )


languages_map +
  geom_text_repel(
    data = top_counties,
    aes(
      label = map_label,
      geometry = geometry
    ),
    stat = "sf_coordinates",
    seed = 1234,
    box.padding = unit(10, "pt"),
    segment.color = "gray30",
    segment.curvature = -0.1,
    arrow = arrow(length = unit(2, "pt"), type = "closed"),
    color = "white",
    bg.color = "grey30",
    bg.r = 0.15
  )

