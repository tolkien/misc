library(shiny)
shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    x  <- autompg[, input$Xvar] 
    y  <- autompg[,input$Yvar]
    plot(x,y,col=input$colchoose,pch=16)
    if(input$linechoose==1)
    {  abline(lm(y~x),lwd=2)
    } else 
    {  lines(lowess(x,y,f=input$spanAdjust),lwd=2)
    }
  })
})