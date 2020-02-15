library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme = shinytheme("united"),
    titlePanel("PSPS- CPT explorer"), ## Application title
    
    ## First filter
    fluidRow(
        column(width=4, textInput("starts_str", "Codes start with:")),
        column(width=8, 
               p("Use this box to filter the code numbers by their prefix. For example, the range",
                 a("60000 to 64999", href="https://coder.aapc.com/cpt-codes-range/1762"), 
                 "are for surgical procedures on the nervous system, and",
                 a("61623-61651", href="https://coder.aapc.com/cpt-codes-range/1812"),
                 "is a subset of those codes for Endovascular Therapy Procedures on the",
                 "Skull, Meninges, and Brain. So typing in", code("616"), "will pre-filter",
                 "the box below to only show codes starting with", code("616XX")),
               p("Leave it blank to include all codes for the filters below."))
    ),
    hr(),
    
    
    #############################
    ##    Specialty sliders    ##
    #############################
    fluidRow(
       column(width=6,
              sliderInput("IR_th", "IR cutoff:", round=3,
                          min = 0, max = 1000, width="100%",
                          value = 15, step=5),
              sliderInput("NSG_th", "NSG cutoff:", round=3,
                          min = 0, max = 1000, width="100%",
                          value = 15, step=5)
       ),
       column(width=6,
              sliderInput("Vasc_th", "Vascular cutoff:", round=3,
                          min = 0, max = 1000, width="100%",
                          value = 0, step=5),
              sliderInput("Neuro_th", "Neurology cutoff:", round=3,
                          min = 0, max = 1000, width="100%",
                          value = 0, step=5)
       )
    ),
    hr(),
    
    ########################
    ##    Selector box    ##
    ########################
    fluidRow(
       column(width=7,
              p("The four slider bars above are used to exclude codes that were not billed for at least",
                "XXX number of times for (at least one year of the data) for that specialty. This can be",
                "used to exclude procedures that are not done frequently by a specialty."),
              p("For example, neurosurgery billed for code",code("73000"),"12 times in 2011",
                "(which was their top year for this code). By default this code is not shown as an",
                "option in the box, because the neurosurgery slider is set to exclude anything below",
                "15. Moving that slider to a value lower than 12 makes the code", code("73000"),
                "an option again.")
       ),
       # Code selecter
       column(width=5, wellPanel(
           p('Use this box to select CPT codes to be displayed in the figures below'),
           uiOutput("select_filtered_codes")
       ))
       
    ),
    
    ###########################
    ##    Figures / table    ##
    ###########################
    plotOutput("figure_abs"),
    plotOutput("figure_pct"),
    DT::dataTableOutput("data_table"),
    verbatimTextOutput("console")

))
