#' Import data from the DIME study dataset
#'
#' @param file_path Path to the CSV file
#'
#' @returns A data frame
#'
import_dime <- function(file_path) {
  data <- file_path %>%
    readr::read_csv(
      show_col_types = FALSE,
      name_repair = snakecase::to_snake_case,
      n_max = 100
    )
  return(data)
}

#' Import all dime csv files, in a folder into one data frame. So the hole dime folder with all data in it
#'
#' @param folder_path Path to DIME data
#'
#' @returns: return to all the data fram
#'
import_csv_files <- function(folder_path) {
  files <- folder_path %>%
    fs::dir_ls(glob = "*.csv")

  data <- files %>%
    purrr::map(import_dime) %>%
    list_rbind(names_to = "file_path_id")

  return(data)
}

#' Get participants ID from dataset
#'
#' @param path to get ID data
#'
#' @returns ID
#'
get_participant_id <- function(data) {
  data_with_id <- data %>%
    dplyr::mutate(
      id = stringr::str_extract(
        file_path_id,
        "[:digit:]+\\.csv$"
      ) %>%
        stringr::str_remove("\\.csv$") %>%
        base::as.integer(),
      .before = file_path_id
    ) %>%
    dplyr::select(-file_path_id)
  base::return(data_with_id)
}

#' To nye kolonner, der skiller dato og tid fra hinanden, som ellers var samlet i en kolonne.
#'
#' @param data et dataframe(som enten er i vores tilfælde for cgm eller sleep data)
#' @param column den kolonne, som vi skulle splitte op fordi der både var tid og dato sammen i en kolonne
#'
#' @returns 2 kolonner fremfor tidligere en kolonne
#'
prepare_dates <- function(data, column) {
  prepared_dates <- data |>
    mutate(
      date = as_date({{ column }}),
      hour = hour({{ column }}),
      .before = {{ column }}
    )

  return(prepared_dates)
}

#' Clean an prepare the cgm data for joining
#'
#' @param data the cgm dataset
#'
#' @returns a cleaner data frame
clean_cgm <- function(data) {
  cleaned <- data |>
    get_participant_id() |>
    prepare_dates(device_timestamp) |>
    dplyr::rename(glucose = historic_glucose_mmol_l)
  return(cleaned)
}
