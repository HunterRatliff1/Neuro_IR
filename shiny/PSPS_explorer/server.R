library(shiny)
library(ggthemes)
library(scales)

man_color <- scale_color_manual(values = c("IR"           = "#1B9E77", 
                                           "Neurosurgery" = "#D95F02",
                                           "Vascular"     = "#7570B3", 
                                           "Neurology"    = "#E7298A"))


shinyServer(function(input, output) {
    
    ##################################
    ##    Reactive: Filter codes    ##
    ##################################
    prefix_codes <- reactive({
        ### If the user provides a prefix to filter
        ### the CPT codes by, returns a filtered version
        ### containing only codes matching that prefix
        
        prefix <- str_c("^", input$starts_str, collapse = "")
        
        # only filter if value is given
        if(length(prefix>1)) {
            new_codes <- all_codes[str_which(all_codes, prefix)]
        } else({new_codes <- all_codes})
        
        new_codes
    })
    
    sliderFilteredCodes <- reactive({
        ### After applying the prefix filter, this returns
        ### another filter based on the slider values
        codes <- prefix_codes()

        ## get slider values
        th_IR    <- input$IR_th
        th_NSG   <- input$NSG_th
        th_Vasc  <- input$Vasc_th
        th_Neuro <- input$Neuro_th
        
        codes2 <- df_max %>%
            filter(CPT %in% codes) %>%
            filter(IR>=th_IR, Neurosurgery>=th_NSG,
                   Vascular>=th_Vasc, Neurology>=th_Neuro) %>%
            .$CPT
        
        # return value
        codes2
    })
    
    
    ##########################
    ##    Conditional UI    ##
    ##########################
    output$select_filtered_codes <- renderUI({
        ### Generates a custom select UI that only
        ### provides CPT codes conditional on the
        ### filters applied in sections above
        
        codes <- sliderFilteredCodes()
        label_text <- str_glue("CPT codes: ({length(codes)} codes meet criteria)")
        
        # Render the select list with filtered codes
        selectInput("cpt_codes", label = label_text, 
                    multiple = T, selected = "61624",
                    choices=c(codes,"61624"))
    })
    
    
    #################################
    ##    Reactive: data filter    ##
    #################################
    get_data <- reactive({
        ### Filters data frame to only include the
        ### user's selected CPT code(s)
        
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
