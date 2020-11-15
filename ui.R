library(shiny)
library(shinythemes)
library(plotly)
library(leaflet)
load("data.rda")
load("coordo.rda")

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("flatly"),
  navbarPage("Europe's CO2 Emission data visualization",
             
             #-- First tab, general map
             tabPanel("Map",
                      sidebarLayout(
                        sidebarPanel(
                          
                          #-- Slider to choose the year
                          sliderInput("year_map", "Choose the year :",
                                      min = 1900, max = 2015,
                                      value = 1960,
                                      width = '250px',
                                      sep = "",
                                      step = 10),
                          
                          
                          #-- Submit button
                          actionButton(
                            inputId = "submit_loc_3",
                            label = "Submit"),
                          
                          plotlyOutput('plot_6')
                          
                          
                        ),
                        
                        mainPanel(
                          leafletOutput('mapEU', width = 1100, height = 800)
                        )
                      )
             ),
             
             #-- Second tab is for time series plot and stats
             tabPanel("Visualization and summary",
                        sidebarLayout(
                            sidebarPanel(
                              tags$style(".well {background-color:white;}"),
                              fluidRow(
                                column(width = 6,
                                       #-- Define the check boxes that contain the countries
                                       #shinythemes::themeSelector(),
                                       checkboxGroupInput(inputId = "id_check_2",
                                                          label = "Select Countries", 
                                                          selected = "France",
                                                          choices = c("France" = "France", 
                                                                      "Germany" = "Germany", 
                                                                      "Italy" = "Italy",
                                                                      "Poland" = "Poland",
                                                                      "UK" = "UK"))
                                       ),
                                column(width = 6,
                                       #-- Define slider for the years to take into account
                                       sliderInput("year", "Years Range :",
                                                   min = 1900, max = 2015,
                                                   value = c(1950,2010),
                                                   width = '250px',
                                                   sep = ""),
                                       
                                       #-- Define the action button to update by choice of the user
                                       actionButton(
                                         inputId = "submit_loc",
                                         label = "Submit")
                                )
                                
                                
                                       ),
                              
                              #-- put the box plot here
                              plotlyOutput('plot_3')
                                       
                                ),
                            mainPanel(
                              plotlyOutput('plot_1'),
                              plotlyOutput('plot_2')),
                            fluid = FALSE
                            
                        )
                        ),
             tabPanel("France",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("deg", "Choose degree basis to fit :",
                                      min = 1, max = 3,
                                      value = 1,
                                      width = '250px',
                                      step = 1),
                          verbatimTextOutput("summary")
                        ),
                        mainPanel(
                          plotlyOutput('plot_4')
                        )
                      )
                      
                      )
               )
    ))