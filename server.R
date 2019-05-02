#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

#Read the dataset
data<-read.csv("C:\\Users\\karun\\Desktop\\goose_rawdata.csv")

#Let us remove the rows where the value of gwar is missing
data_nomissing<-data[which(!is.na(data$gwar)),]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  model3<-lm(data = data_nomissing, gwar~ppf+league_average_gpct+goose_eggs+broken_eggs)
  
  #makes the residual plot 
  output$distPlot <- renderPlot({
    ggplot() + geom_point(aes(x=data_nomissing$gwar, y=resid(model3)), size = 1.5) + 
      geom_hline(yintercept = 0)+
      ggtitle("Residual Scatter Plot")+theme_minimal()+theme(plot.title = element_text(size = 40))
  })
  
  #predict using the user selected values
  output$prediction <- renderText({ 
    predicted_value<-paste("Prediction for gwar (goose wins above replacement) : ", round(predict(model3,newdata = data.frame(ppf=input$ppf,
                                                                                                                              league_average_gpct=input$league_average_gpct,
                                                                                                                              goose_eggs=input$goose_eggs,
                                                                                                                              broken_eggs=input$broken_eggs)),2))
    predicted_value
  })
  
  
})


