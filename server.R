library(shiny)
library(ggplot2)
library(plotly)
library(tidyverse)
library(leaflet)
load("data.rda")
load("coordo.rda")

shinyServer(function(input, output,session) {
    
    #-- Define the variables with each selection by the user for the first tab
    observeEvent(
        eventExpr = input$submit_loc,
        handlerExpr = {
            df <- filter(df_tab1, Country %in% input$id_check_2 & Year >= input$year[1] & Year <= input$year[2])
            
            
            #-- Display the first plot (Time series)
            output$plot_1 <- renderPlotly({
                input$submit_loc
                plot_ly(df, x = ~Year, y = ~CO2_Emission, color = ~Country,
                        colors = "Set1", type = 'scatter', mode = 'lines') %>% 
                    layout(yaxis = list(title = "Carbon Emission"),
                           xaxis = list(title = ""),
                           title = "Time Series showing CO2 emissions per country")
            })
            
            #-- Display the second plot (bar plot)
            output$plot_2 <- renderPlotly({
                input$submit_loc
                plot_ly(df, x = ~Year, y = ~CO2_Emission, color = ~Country,
                        colors = "Set1", type = 'bar') %>% 
                    layout(yaxis = list(title = "Carbon Emission"),
                           title = "Bar plot showing CO2 emissions per country")
            })
            
            #-- Display third plot (under the cursor) which is a box plot
            output$plot_3 <- renderPlotly({
                input$submit_loc
                plot_ly(df, y = ~Country, x = ~CO2_Emission, color = ~Country,
                        colors = "Set1", type = 'box', boxpoints = "all", jitter = 0.3,
                        pointpos = -1.8) %>% layout(width = 500, 
                                                    height = 625, 
                                                    showlegend = F,
                                                    yaxis = list(title = "Box plot of CO2 emissions per country",
                                                                 tickangle = -90,
                                                                 titlefont = list(size = 16)),
                                                    xaxis = list(title = "Carbon Emission"))
            })
        })
    
    
    #-- Observe Event for the map
    observeEvent(
        eventExpr = input$submit_loc_3,
        handlerExpr = {
            df_map <- filter(df_EU_coordo, Year %in% input$year_map)
            df_map <- df_map[order(df_map$CO2_Emission),]
            
            #-- Display the map
            output$mapEU <- renderLeaflet({
                input$submit_loc_3
                
                #-- Define map
                leaflet(data=df_map) %>% 
                    addTiles() %>% 
                    addCircleMarkers(lng = df_map$lon, lat = df_map$lat, 
                                     radius = ~10*(CO2_Emission-mean(CO2_Emission))/sd(CO2_Emission),
                                     fillOpacity = 0.5,
                                     popup = ~paste(as.character(df_map$Country))) %>%
                    setView(lng=13.19996,lat=47.20003,zoom=5)
            })
            output$plot_6 <- renderPlotly({
                input$submit_loc_3
                plot_ly(df_map, y = ~Country, x = ~CO2_Emission, type = 'bar', orientation='h')%>% 
                    layout(width = 450,
                           height = 650,
                           yaxis = list(title = "",
                                        categoryorder = "array",
                                        categoryarray = ~Country),
                           xaxis = list(title = "CO2 Emission"))
            })
            
            })
    output$plot_4 <- renderPlotly({
        
        line.fmt = list(dash="solid", width = 1.5, color=NULL)
        m1 = lm(df_tab3$CO2_Emission~df_tab3$Year)
        m2 = lm(df_tab3$CO2_Emission~df_tab3$Year+I(df_tab3$Year^2))
        m3 = lm(df_tab3$CO2_Emission~df_tab3$Year+I(df_tab3$Year^2)+I(df_tab3$Year^3))
        
        g <- plot_ly(df_tab3, x = ~Year, y = ~CO2_Emission, colors = "darkblue",
                type = 'scatter', size = 2, mode = "markers")
        g <- g %>% add_trace(x = ~Year, y = ~CO2_Emission, 
                             marker = list(color = 'rgba(17, 157, 255, 0.5)', 
                                           size = 20,
                                           line = list(color = 'rgb(231, 99, 250)',
                                                       width = 2)), showlegend = F)
        g <- g %>% layout(width = 1000, 
                          height = 800, 
                          showlegend = F,
                          yaxis = list(title = "Carbon Emission"),
                          xaxis = list(title = "Year"),
                          title = "CO2 Emissions of France in the last 35 Years")
        if (input$deg == 1){
            g <- g %>% add_lines(x = ~Year, y = predict(m1), line= line.fmt)
            output$summary <- renderPrint({
                data.frame("R Squared" = summary(m1)$adj.r.squared, "Standard Error" = summary(m1)$sigma)
                 })
        }
        if (input$deg == 2){
            g <- g %>% add_lines(x = ~Year, y = predict(m2), line= line.fmt)
            output$summary <- renderPrint({
                data.frame("R Squared" = summary(m2)$adj.r.squared, "Standard Error" = summary(m2)$sigma)
            })
        }
        if(input$deg == 3){
            g <- g %>% add_lines(x = ~Year, y = predict(m3), line= line.fmt)
            output$summary <- renderPrint({
                data.frame("R Squared" = summary(m3)$adj.r.squared, "Standard Error" = summary(m3)$sigma)
            })
        }
        g
        
    })
})