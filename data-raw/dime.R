library(here)
library(fs)

dime_link <- "https://github.com/rostools/r-cubed-intermediate/raw/refs/heads/main/data/dime.zip"
download.file(dime_link, destfile = here("data-raw/dime.zip"))
usethis::use_git_ignore("data-raw/dime.zip")
# Remove leftover folder so unzipping is always clean
dir_delete(here("data-raw/dime"))

unzip(
  here("data-raw/dime.zip"),
  exdir = here("data-raw/dime/")
)
# NOTE: You don't need to run this code,
# its here to show how we got the file list.
fs::dir_tree("data-raw/")
usethis::use_git_ignore("data-raw/dime/")
