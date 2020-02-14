# From get_data.R
library(tidyverse)
theme_set(theme_bw()+theme(legend.position = "bottom"))

data <- read_csv("full_data.csv") %>%
  mutate(CPT = str_pad(CPT, 5, pad="0"))

all_codes <- unique(data$CPT)
all_codes_num <- as.numeric(all_codes)


library(googlesheets4)
# options(
#   gargle_oauth_cache = ".secrets",
#   # gargle_oob_default = TRUE,
#   gargle_oauth_email = "hunterratliff1@gmail.com"
# )
sheets_deauth()

gs <- as_sheets_id("https://docs.google.com/spreadsheets/d/1IR2TCwYZ-BX3MaVfZVh8vA1DZGRu965MDxzNXB1avqc/") %>%
  read_sheet("ShinyCPT") %>%
  mutate(CPT=as.numeric(CPT)) %>%
  mutate(CPT = str_pad(CPT, 5, pad="0"))





# library(googledrive)
# # designate project-specific cache
# options(gargle_oauth_cache = ".secrets")
# gargle::gargle_oauth_cache()
# # drive_auth(use_oob = TRUE, cache = ".secrets")
# 
# # see your token file in the cache, if you like
# list.files(".secrets/")
