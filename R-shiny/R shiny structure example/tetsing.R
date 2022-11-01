library(shiny)

ui = shinyUI(fluidPage(
  
  titlePanel("Defining time periods"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("num_periodsnr", label = "Desired number of time periods?",
                   min = 1, max = 10, value = 2),
      uiOutput("period_cutpoints"),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      textOutput("nr_of_periods"),
      textOutput("cutpoints")
    )
  )
))

server = shinyServer(function(input, output, session) {
  
  library(lubridate)
  
  output$nr_of_periods <- renderPrint(input$num_periodsnr)
  
  dates <- seq(ymd('2016-01-02'), ymd('2017-12-31'), by = '1 week')
  
  output$period_cutpoints<-renderUI({
    print(num_periodsnr)
    req(input$num_periodsnr)
    lapply(1:(input$num_periodsnr-1), function(i) {
      selectInput(inputId=paste0("cutpoint",i), 
                  label=paste0("Select cutpoint for Time Periodss ", i, ":"),
                  choices=dates)
    })
  })
  
  seldates <- reactiveValues(x=NULL)
  observeEvent(input$submit, {
    seldates$x <- list()
    lapply(1:(input$num_periodsnr-1), function(i) { 
      seldates$x[[i]] <- input[[paste0("cutpoint", i)]]
    })
  })
  
  output$cutpoints <- renderText({as.character(seldates$x)})
})

shinyApp(ui = ui, server = server)