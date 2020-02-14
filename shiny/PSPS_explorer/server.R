#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggthemes)
library(scales)

man_color <- scale_color_manual(values = c("IR"           = "#1B9E77", 
                                           "Neurosurgery" = "#D95F02",
                                           "Vascular"     = "#7570B3", 
                                           "Neurology"    = "#E7298A"))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    
    output$select_filtered_codes <- renderUI({
        filt <- input$range_slider
        
        # only codes meeting the range given
        codes <- tibble(codes_num = all_codes_num,
                        codes_chr = all_codes) %>%
            filter(codes_num >= filt[1],
                   codes_num <= filt[2]) %>%
            .$codes_chr
        
        # Render the select list with filtered codes
        selectInput("cpt_codes", "CPT codes", multiple = T, selected = "61624",
                    choices=c(codes,"61624"))
    })
    
    get_data <- reactive({
        data %>%
            filter(CPT %in% input$cpt_codes) %>%
            group_by(CPT, data_year) %>%
            mutate(totalYr = sum(num)) 
    })
    
    
    ########################
    ##    RENDER PLOTS    ##
    ########################
    output$figure_abs <- renderPlot({
        df <- get_data()
        df %>%
            ggplot(aes(x=data_year, y=num, color=Specialty)) +
            geom_line() +
            man_color +
            labs(x="Year", y="Total times billed") +
            facet_wrap("CPT", scales = "free_y")
        
    })
    output$figure_pct <- renderPlot({
        df <- get_data()
        df %>%
            ggplot(aes(x=data_year, y=num/totalYr, color=Specialty)) +
            geom_line() + 
            man_color + scale_y_continuous(labels=percent) +
            labs(x="Year", y="% of total") +
            facet_wrap("CPT")
        
    })
    
    ########################
    ##    RENDER TABLE    ##
    ########################
    output$data_table <- DT::renderDT(rownames=F, options = list(searching = FALSE),{
        df <- get_data()
        
        gs %>%
            semi_join(df) %>%
            select(CPT:full_description)
    })
    
    
    ######################################
    ##    Render print for debugging    ##
    ######################################
    output$console <- renderPrint({
        print("ignore this box, I use it for debugging the app")
    })

    

})
