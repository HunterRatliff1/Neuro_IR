#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("united"),

    # Application title
    titlePanel("PSPS- CPT explorer"),
    
    sliderInput("range_slider", "Code Range:", 
                min=0, max=99999,
                sep="", width="100%",
                value=c(min(all_codes_num),max(all_codes_num))),
    
    uiOutput("select_filtered_codes"),
    # selectInput("cpt_codes", "CPT codes", multiple = T, selected = "61624",
    #             choices=all_codes),
    
    plotOutput("figure_abs"),
    plotOutput("figure_pct"),
    DT::dataTableOutput("data_table"),
    verbatimTextOutput("console")

))
