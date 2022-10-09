setwd("C:/MyFiles/Learning/git/R-Projects/R-shiny/App-5")

library(shiny)
library(maps)
library(mapproj)

counties <- readRDS("census-app/data/counties.rds")

source("census-app/helpers.R")

# counties.rds
# counties.rds is a dataset of demographic data for each county in the United States, collected with the UScensus2010 R package. You can download it here.

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({    
    args <- switch(input$var,
      "Percent White" = list(counties$white, "darkgreen", "% White"),
      "Percent Black" = list(counties$black, "black", "% Black"),
      "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
      "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
        
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
}

# Run app ----
shinyApp(ui, server)

# Run the app ----
shinyApp(ui = ui, server = server)