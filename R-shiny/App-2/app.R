library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Basic widgets"),

  fluidRow(
    column(3,
      h1(
        strong(
          "Census Vis"
        )
      )
    )
  ),
  sidebarLayout(
    sidebarPanel(
      h4(
        strong(
          span(
            "Create demographic maps with information from the 2010 US Census.", style="color:grey"
          )
        )
      ),
      selectInput("select", 
        h4(
          strong("Choose a variable to display"),
        ), 
        choices = list("Percent White" = "White", "Percent Black" = "Black","Percent Hispanic" = "Hispanic", "Percent Asian" = "Asian"), selected = "Percent White"),
      sliderInput("slider2", "",min = 0, max = 100, value = c(0, 100))
    ),
    mainPanel()
  )  
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)