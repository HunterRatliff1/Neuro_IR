library(shiny)
library(shinythemes)
library(scales)
library(tidyverse)
library(ggthemes)
theme_set(theme_bw()+theme(legend.position = "bottom"))

###########################
##    From get_data.R    ##
###########################
# This data is pre-filtered in get_data.R and only contains codes
# that meet the following criteria:
#   - A code must be billed for by >1 specialty
#   - The total number of times a code was billed over the total
#     time period must be greater than 100
data_path <- "full_data.csv"
if(FALSE){
  # only run for non-deployment
  data_path <- "shiny/PSPS_explorer/full_data.csv"
}
data <- read_csv(data_path) %>%
  mutate(CPT = str_pad(CPT, 5, pad="0"))
rm(data_path)


all_codes <- unique(data$CPT)
all_codes_num <- as.numeric(all_codes)


## df_max: Each column represents the maximum number of
##         times a specialty billed for a code in any 
##         of the years on file. Used for filtering out
##         codes that were not billed for at least XXX
##         number of times by a specialty
df_max <- data %>%
  group_by(CPT, Specialty) %>%
  summarise(max = max(num)) %>%
  mutate(max = replace_na(max, 0)) %>%
  spread("Specialty", "max", fill=0)


############################
##    get google sheet    ##
############################
library(googlesheets4)
sheets_deauth() # because sheet is link sharing

gs <- as_sheets_id("https://docs.google.com/spreadsheets/d/1IR2TCwYZ-BX3MaVfZVh8vA1DZGRu965MDxzNXB1avqc/") %>%
  read_sheet("ShinyCPT") %>%
  mutate(CPT=as.numeric(CPT)) %>%
  mutate(CPT = str_pad(CPT, 5, pad="0"))


