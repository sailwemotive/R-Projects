function(input, output) {
  questions <- c(questionnaire_data$question)
  
  options <- c(questionnaire_data$options)
  splited_options <- strsplit(options,",")
  
  # Description: Generating select boxes for each question present in CSV.
  # output ID: questionnaire_section
  # return: Render select box on UI
  output$questionnaire_section <- renderUI({
    lapply(1:(nrow(questionnaire_data)), function(i) {
      selectInput(inputId=paste0(i), 
                  label=paste0(questions[i]),
                  choices=c('Select output',splited_options[[i]]))
    })
  })
  
  # Description: Take a reactive dependency on input$submit, but not on any of the stuff inside the function
  # Expression: eventReactive
  # input ID: button
  # return: Dataframe with columns Question No. and User Answer. Dataframe contains user selected data.
  AllInputs <- eventReactive(input$button, {
    myvalues <- NULL
    for(i in 1:length(names(input))){
      myvalues <- as.data.frame(rbind(myvalues,(cbind(names(input)[i],input[[names(input)[i]]]))))
    }
    names(myvalues) <- data.frame("Question No.","User Answer")
    row_to_keep <- c(myvalues['Question No.'] != 'button')
    myData <- myvalues[row_to_keep,]
    data <- myData[order(myData['Question No.'], decreasing = FALSE), ]   
  })
  
  output$responses <- renderTable({
    AllInputs()
  })
}