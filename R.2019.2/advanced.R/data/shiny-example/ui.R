
library(shiny)
shinyUI(fluidPage(
  titlePanel("Scatter plot with lines : autompg"),
  sidebarLayout( 
    sidebarPanel(
      selectInput(inputId = "Xvar", 
                   label = "X variable",
                   choices = colnames(autompg),
                   selected = colnames(autompg)[1]),
      selectInput(inputId = "Yvar", 
                  label = "Y variable",
                  choices = colnames(autompg),
                  selected =colnames(autompg)[2]),
      radioButtons(inputId = "colchoose", label = "Color of points",
                   choices = list("black"=1,"red"=2,"green"=3,"blue"=4),
                             selected = 1),
      radioButtons(inputId = "linechoose", label = "lines",
                   choices = list("lm"=1,"lowess"=2),selected = 1),     
      sliderInput(inputId = "spanAdjust",
                  label = "lowess span",
                  min = 0,
                  max = 1,
                  value = 0.5)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
))


