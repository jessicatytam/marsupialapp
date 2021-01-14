library(shiny)
library(shinythemes)
library(plotly)
library(ggplot2)
library(dplyr)

#the ui
ui <- (fluidPage(
  
  titlePanel("Impact factors of publications of Australasian marsupials"),
  
  fluidPage(sidebarLayout(
    sidebarPanel(
      
      selectInput(inputId = "x",
                label = "x-variable",
                choices = c("Publications", "Citations", "Journals", "Articles", "Reviews", "Years publishing")),
      selectInput(inputId = "y",
                label = "y-variable",
                choices = c("h-index", "m-index", "i10 index", "h5 index")),
      selectInput(inputId = "colour",
                label = "Colour by",
                choices = c("Species", "Genus", "Family", "Order", "Class")),
      width = 2
  ),
  
  mainPanel(
    plotlyOutput("indexplot"),
    width = 10)
  
  ))
  
))

#the server
server <- function(input, output) {
  
  xvar <- reactive({ #making the x-variable reactive
    switch(input$x,
           "Publications" = "publications",
           "Citations" = "citations",
           "Journals" = "journals",
           "Articles" = "articles",
           "Reviews" = "reviews",
           "Years publishing" = "years_publishing")
  })
  
  yvar <- reactive({ #making the y-variable reactive
    switch(input$y,
           "h-index" = "h",
           "m-index" = "m",
           "i10 index" = "i10",
           "h5 index" = "h5")
  })
  
  colby <- reactive({ #making the colour reactive
    switch(input$colour,
           "Species" = "genus_species",
           "Genus" = "genus",
           "Family" = "family",
           "Order" = "order",
           "Class" = "class")
  })
  
  output$indexplot <- renderPlotly({ #actual plot
    
    plotresults <- ggplot(marsupials,
           aes_string(x = xvar(),
                      y = yvar(),
                      colour = colby())) +
      geom_point(size = 2,
                 alpha = 0.5) +
      labs(x = input$x,
           y = input$y,
           colour = input$colour) +
      theme(axis.title.x = element_text(size = 16),
            axis.text.x = element_text(size = 12),
            axis.title.y = element_text(size = 16),
            axis.text.y = element_text(size = 12),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 12))
    
    ggplotly(plotresults) %>% layout(height = 800)
    
  })
  
}

#run app
shinyApp(ui = ui, server = server)

