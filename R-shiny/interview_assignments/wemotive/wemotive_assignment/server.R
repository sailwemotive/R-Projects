source("./config.R")

function(input, output) {
  
  questionnaire_data <- read.csv(input)
  
  options <- c(questionnaire_data$options)
  splited_options <- strsplit(options,",")
  
  output$period_cutpoints<-renderUI({
    lapply(1:(nrow(questionnaire_data)), function(i) {
      selectInput(inputId=paste0("cutpoint",i), 
                  label=paste0("Select cutpoint for Time Periodss ", i, ":"),
                  choices=splited_options[[i]])
    })
  })
  
  # You can access the value of the widget with input$select, e.g.
  output$value <- renderPrint({ input$select })
}