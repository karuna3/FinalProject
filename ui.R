#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Shiny App Demonstration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("ppf",
                  "ppf:",
                  min = 88,
                  max = 129,
                  value = 108.5),
      sliderInput("league_average_gpct",
                  "league_average_gpct:",
                  min = 0.6614537,
                  max = 0.8218148,
                  value = 0.7416342),
      sliderInput("goose_eggs",
                  "goose_eggs:",
                  min = 0,
                  max = 82,
                  value = 41),
      sliderInput("broken_eggs",
                  "broken_eggs:",
                  min = 0,
                  max = 22,
                  value = 11)
    ),
    
    # Show the texts and plots
    mainPanel(
      textOutput("prediction"),
      plotOutput("distPlot")
      
    )
  )
  
))