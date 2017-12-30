#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Play CSI", theme = shinytheme('darkly'),
  tabPanel("Find type of glass",
           sidebarPanel(width=8,
                        fluidRow(
                          column(12,
                                 h2("Choose glass properties"),
                                 p("Use the sliders to set the values for the properties.
                                 The density plots help visualize your choice."),
                                 p("When done push the 'Find glass type' button"))
                        ),
                        fluidRow(
                          column(12,
                          actionButton(
                            inputId = "submit",
                            label = "Find glass type"
                          ),
                          
                          actionButton(
                            inputId = "reset",
                            label = "Reset"
                          ),
                          br(), br())),
                        
                        fluidRow(
                          column(6, 
                                 plotOutput("plotRI", height = "180px"),
                                 sliderInput("RI",
                                            "Refractve Index",
                                            min = round(min(fgl$RI), 1),
                                            max = round(max(fgl$RI), 1),
                                            value = round(mean(fgl$RI),1)           ),
                                 plotOutput("plotMg", height = "180px"),
                                 sliderInput("Mg",
                                            "Weight percentage Magnese",
                                            min = round(min(fgl$Mg), 1),
                                            max = round(max(fgl$Mg), 1),
                                            value = round(mean(fgl$Mg), 1)           ),
                                 plotOutput("plotSi", height = "180px"),
                                 sliderInput("Si",
                                            "Weight percentage Silicon",
                                            min = round(min(fgl$Si), 1),
                                            max = round(max(fgl$Si), 1),
                                            value = round(mean(fgl$Si), 1)           ),
                                 plotOutput("plotCa", height = "180px"),
                                 sliderInput("Ca",
                                             "Weight percentage calcium",
                                             min = round(min(fgl$Ca), 1),
                                             max = round(max(fgl$Ca), 1),
                                             value = round(mean(fgl$Ca), 1)           ),
                                 plotOutput("plotFe", height = "180px"),
                                 sliderInput("Fe",
                                             "Weight percentage Iron",
                                             min = round(min(fgl$Fe), 1),
                                             max = round(max(fgl$Fe), 1),
                                             value = round(mean(fgl$Fe), 1)           )
                                 ),
                          column(6,
                                 plotOutput("plotNa", height = "180px"),
                                 sliderInput("Na",
                                             "Weight percentage Sodium",
                                             min = round(min(fgl$Na), 1),
                                             max = round(max(fgl$Na), 1),
                                             value = round(mean(fgl$Na), 1)           ),
                                 plotOutput("plotAl", height = "180px"),
                                 sliderInput("Al",
                                             "Weight percentage Aluminimum",
                                             min = round(min(fgl$Al), 1),
                                             max = round(max(fgl$Al), 1),
                                             value = round(mean(fgl$Al), 1)           ),
                                 plotOutput("plotK", height = "180px"),
                                 sliderInput("K",
                                             "Weight percentage Potasium",
                                             min = round(min(fgl$K), 1),
                                             max = round(max(fgl$K), 1),
                                             value = round(mean(fgl$K), 1)           ),
                                 plotOutput("plotBa", height = "180px"),
                                 sliderInput("Ba",
                                             "Weight percentage Barium",
                                             min = round(min(fgl$Ba), 1),
                                             max = round(max(fgl$Ba), 1),
                                             value = round(mean(fgl$Ba), 1)           ))
                                 )
                        
           ),
                        
           mainPanel(width=4,
                     h1("Prediction"),
                     p("Fill in the properties of your piece of glass."),
                     p("After hitting the 'Find glass tyoe' button the prediction is printed as a list of probabilities and the most probable type is also listed."),
                     tableOutput("probability"),
                     textOutput("prediction")
                     )
           ),
  tabPanel("Explanation",
           includeMarkdown("explanation.Rmd"))
))
