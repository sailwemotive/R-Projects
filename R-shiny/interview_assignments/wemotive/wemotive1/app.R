# Packages ----
library(shiny) # Required to run any Shiny app

# Loading data ----
questionnaire_data <- read.csv('./data/questionnaire.csv')

# ui.R ----
ui <- fluidPage()

# server.R ----
server <- function(input, output) {}

# Run the app ----
shinyApp(ui = ui, server = server)
