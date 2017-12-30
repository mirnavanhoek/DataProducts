#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(ggplot2)
library(lattice)
library(randomForest)
library(caret)


set.seed(336699)

buildRFModel <- function() {
  fitControl <- trainControl(method = "cv", number = 5)
  fitRF <- train(type ~ ., data = fgl,
                 method = "rf",
                 trControl = fitControl)
  return(fitRF)
}

buildRFManual <- function() {
  fitRF <- randomForest(type~., data=fgl, mtry=2)
  return(fitRF)
}

predictGlassProb <- function(trainedModel, inputs) {
  prediction <- predict(trainedModel,
                        newdata = inputs,
                        type = "prob",
                        predict.all = TRUE)
  return(renderTable(prediction))
}

predictGlassProbManual <- function(RFModel, inputs){
  prediction <- predict(RFModel,
                           newdata=inputs,
                           type = "prob")
  return(renderTable(prediction))
}

predictGlass <- function(trainedModel, inputs) {
  prediction <- predict(trainedModel,
                        newdata = inputs)
  return(as.character(prediction))
}

producePlot <- function(data, X, Group, Fill, Xlab, input){
  p <- ggplot(data, aes(x=X, group=data[[Group]], fill= Fill)) +
    geom_density(position="identity", alpha=0.5) +
    scale_fill_discrete(name=Group) +
    theme_bw() +
    xlab(Xlab) +
    geom_vline(xintercept = input, color="red", size=2)
    #scale_x_continuous(limits = c(round(min(X) / 2, 1),
    #                              round(max(X) * 1.25, 1)))
  return(p)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
   data("fgl")
    
   buildModel <- reactive({
# Using caret's train (in fct buildRFModel) takes too long and shinyapps.io disconnects
# Using bestTune$mtry from train result and run randomForest fct in buildRFManual instead.
# :(
# I will change back to using buildRFModel when I find out how to prevent shintapps.io
# disconecting
     
#     buildRFModel()
     buildRFManual()
   })
   
   output$plotRI <- renderPlot({
    producePlot(fgl, fgl$RI, "type", as.factor(fgl$type), "Refractive Index", input$RI)
   })
   output$plotNa <- renderPlot({
     producePlot(fgl, fgl$Na, "type", as.factor(fgl$type), "Sodium", input$Na)
   })
   output$plotMg <- renderPlot({
     producePlot(fgl, fgl$Mg, "type", as.factor(fgl$type), "Magnese", input$Mg)
   })
   output$plotAl <- renderPlot({
     producePlot(fgl, fgl$Al, "type", as.factor(fgl$type), "Aluminium", input$Al)
   })
   output$plotSi <- renderPlot({
     producePlot(fgl, fgl$Si, "type", as.factor(fgl$type), "Silicon", input$Si)
   })
   output$plotK <- renderPlot({
     producePlot(fgl, fgl$K, "type", as.factor(fgl$type), "Potasium", input$K)
   })
   output$plotCa <- renderPlot({
     producePlot(fgl, fgl$Ca, "type", as.factor(fgl$type), "Calcium", input$Ca)
   })
   output$plotBa <- renderPlot({
     producePlot(fgl, fgl$Ba, "type", as.factor(fgl$type), "Brium", input$Ba)
   })
   output$plotFe <- renderPlot({
     producePlot(fgl, fgl$Fe, "type", as.factor(fgl$type), "Iron", input$Fe)
   })
   
   
   observeEvent(
     eventExpr=input$submit,
     handlerExpr = {
       withProgress(message = 'Just a moment...', value = 0, {
         myModel <- buildModel()
       })
       RI <- input$RI
       Na <- input$Na
       Mg <- input$Mg
       Al <- input$Al
       Si <- input$Si
       K <- input$K
       Ca <- input$Ca
       Ba <- input$Ba
       Fe <- input$Fe
       inputs <- data.frame(RI, Na, Mg, Al, Si, K, Ca, Ba, Fe)
       probGlassType <- predictGlassProbManual(myModel, inputs)
       output$probability <- probGlassType
       predGlassType <- predictGlass(myModel, inputs)
       sentence <- "Most likely your piece of glass is of type: "
       output$prediction <- renderText(paste(sentence, predGlassType))
   })
  
   observeEvent(input$reset,{
     updateSliderInput(session, "RI", value = round(mean(fgl$RI),1))
     updateSliderInput(session, "Na", value = round(mean(fgl$Na),1))
     updateSliderInput(session, "Mg", value = round(mean(fgl$Mg),1))
     updateSliderInput(session, "Al", value = round(mean(fgl$Al),1))
     updateSliderInput(session, "Si", value = round(mean(fgl$Si),1))
     updateSliderInput(session, "K", value = round(mean(fgl$K),1))
     updateSliderInput(session, "Ca", value = round(mean(fgl$Ca),1))
     updateSliderInput(session, "Ba", value = round(mean(fgl$Ba),1))
     updateSliderInput(session, "Fe", value = round(mean(fgl$Fe),1))
   })
   

 
       

  })
  
