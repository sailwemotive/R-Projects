# Define server logic required to draw a histogram
server <- function(input, output) {
  
  input_file <- reactive({
    if (is.null(input$dataFile))
      return(NULL)
    
    # actually read the file
    read.csv(file = input$dataFile$datapath)
  })
  
  output$allData <- DT::renderDataTable({
    # render only if there is data available
    req(input_file())
    
    # reactives are only callable inside an reactive context like render
    data <- input_file()
  })
  
  output$result <- renderText({
    paste("You chose", input$state)
  })
}