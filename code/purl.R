library(knitr)
library(fs)
library(tidyverse)

slides_qmds <-
  dir_ls(
    regexp = "slides-"
  )

purl_slides_qmd <- function(input_qmd) {
  output_r_file <- str_replace(input_qmd, "qmd", "R")
  output_r_file <- str_remove(output_r_file, "slides-")
  output_r_file <- str_glue("code/{output_r_file}")

  purl(
    input = input_qmd,
    output = output_r_file
  )
}

walk(slides_qmds, purl_slides_qmd)

r_files <-
  dir_ls(
    path = "code"
  )

remove_separators <- function(file_path) {
  # Read the file
  script_content <- readr::read_lines(file_path) |>
    # Convert to tibble for easier manipulation
    tibble::as_tibble() |>
    # Filter out the separator lines
    dplyr::filter(!stringr::str_detect(value, "^## -{10,}$")) |>
    # Pull back to character vector
    dplyr::pull(value)

  # Write back to file
  readr::write_lines(script_content, file_path)
}

walk(r_files, remove_separators)

remove_chunk_options <- function(file_path) {
  # Read the file
  script_content <- readr::read_lines(file_path) |>
    # Convert to tibble for easier manipulation
    tibble::as_tibble() |>
    # Filter out lines that contain chunk options
    dplyr::filter(!stringr::str_detect(value, "^#\\| .*:.*")) |>
    # Pull back to character vector
    dplyr::pull(value)

  # Write back to file
  readr::write_lines(script_content, file_path)
}

walk(r_files, remove_chunk_options)
