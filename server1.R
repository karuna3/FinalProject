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
  
  model3<-lm(data = data_nomissing, gwar~ppf+league_average_gpct+goose_eggs+broken_eggs) #make the model
  
  #make the residual plot 
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
  
  #description about the dataset and questions which we intended to answer from the model
  output$text <- renderUI({
    
    str1 <- "<h3> Data: </h3> I choose the Goose dataset as it has the required size and some interesting questions can be answered with this.
    The data is compiled by the editor in chief of FiveThirtyEight. The data-contains details on baseball players like
    their name, goos eggs score etc. which can be used to find the comparative rankings of a player."
    str2 <- "My goal is to find any strong relation between goose wins above replacement(gawr) and other variables in the dataset."
    str3 <-" After analysis in last assignment I confimed that the best model included the Pitcher park factor(ppf),
    League-average goose percentage(league_average_gpct), Goose eggs of the player(goose_eggs) and broken eggs for the player(broken_eggs)."
    
    
    cf <- round(coef(model3), 4) 
    eq <- paste0("gwar = ", cf[1],
                 ifelse(sign(cf[2])==1, " + ", " - "), abs(cf[2]), " * ppf ",
                 ifelse(sign(cf[3])==1, " + ", " - "), abs(cf[3]), " * league_average_gpct ",
                 ifelse(sign(cf[3])==1, " + ", " - "), abs(cf[4]), " * goose_eggs ",
                 ifelse(sign(cf[3])==1, " + ", " - "), abs(cf[5]), " * broken_eggs")
    str4 <- paste("<strong> Equation From best model: </strong>  <pre>" , eq , " </pre>")
    
    str5<-"Here the model coefficients imply that a unit change in ppf value leads to a change of 
0.0006104 in gwar, unit change in league_average_gpct leads to a change of -4.9178608
in gwar, a unit change in goose_eggs leads to a change of 0.1421655 in gwar and a unit 
change in value of broken_eggs leads to a change of -0.3661402 in gwar."
    
    str6 <- "<h4> Questions: </h4> 1. Do the dataset can explain the variation in gwar with some reasonable accuracy? 
        </br> Yes. The model mentioned has an R-sqaured value of 0.98 with all the predictors significant. Although, this high R value may be a result of the fact that gwar and other variables are not independent. 
            </br> 2. How the Pitch park factor affects the gwar ?
              </br> The pitch park factor has a very small coefficient but has a very significant positive impact on the gwar. The higher the ppf value the more we can expect the gawr value to be. 
     The small coeff for ppf can be explained by its range which is very large as compared to other predictors involved.
     </br>3.How the League-average goose percentage is related to the overall gwar?
     </br> We can say from the coeff of League-average goose percentage is by keeping all other variables constant 1 unit increase in League-average goose percentage will lead to a 0.0443869 points increase in gwar. "
    
    HTML(paste(str1, str2,str3,str4,str5,str6,sep = '<br/>'))
    
  })
  
})
