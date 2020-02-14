# library(tidyverse)
# #######################################
# ##    READ IN THE MERGED DATA SET    ##
# #######################################
# df_full <- read_csv("~/Neuro_IR/psps-data/merged.csv") %>% 
#   mutate(HCPCS_CD = as.numeric(HCPCS_CD)) %>%
#   filter(!is.na(HCPCS_CD)) %>%
#   rename(CPT=HCPCS_CD) %>%
#   mutate(Specialty = factor(Specialty)) %>%
#   group_by(CPT, Specialty, data_year) %>%
#   
#   rename(num     = PSPS_SUBMITTED_SERVICE_CNT,  # number of times billed
#          charged = PSPS_SUBMITTED_CHARGE_AMT,   # amount of charges submitted by the provider
#          paid    = PSPS_ALLOWED_CHARGE_AMT) %>% # amount allowed by Medicare 
#   summarise(num        = sum(num), 
#             charged    = sum(charged),
#             paid       = sum(paid),
#             n          = n()) 
# 
# 
# 
# #############################################
# ##    Drop any codes that do not appear    ##
# ##        in more than 1 specialty         ##
# ##               --- or ---                ##
# ##    are billed for less than 100 times   ##
# ##    across all specialties and years     ##
# #############################################
# only_once <- df_full %>%
#   group_by(CPT, Specialty) %>%
#   summarise(num=sum(num)) %>%
#   count(CPT) %>%
#   filter(n<=1)
# 
# df_full %>%
#   filter(!CPT %in% only_once$CPT) %>%
#   group_by(CPT) %>% 
#   filter(sum(num)>100) %>% 
#   write_csv("~/Neuro_IR/shiny/PSPS_explorer/full_data.csv")
