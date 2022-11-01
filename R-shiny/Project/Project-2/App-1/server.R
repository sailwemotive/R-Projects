library("shiny")

shinyServer(
  function(input, output, session){
    
    arithmetic.operation <- function() {
      if(input$arithmetic.operation == "Addition"){
        return(input$number1 + input$number2)
      }
      else if(input$arithmetic.operation == "Subtraction"){
        return(input$number1 - input$number2)
      }
      else if(input$arithmetic.operation == "Multiplication"){
        return(input$number1 * input$number2)
      }
      else if(input$arithmetic.operation == "Division"){
        return(input$number1 / input$number2)
      }
    }
    output$arithmetic.operation <- renderText({
      input$number1
    })
    
    # reactive expression
    # output$arithmetic.operation <- renderText({
    #   if(input$arithmetic.operation == "Addition"){
    #     input$number1 + input$number2
    #   }
    #   else if(input$arithmetic.operation == "Subtraction"){
    #     input$number1 - input$number2
    #   }
    #   else if(input$arithmetic.operation == "Multiplication"){
    #     input$number1 * input$number2
    #   }
    #   else if(input$arithmetic.operation == "Division"){
    #     input$number1 / input$number2
    #   }
    # })
    
    #
    # # event reactive expression
    # text_reactive <- eventReactive( input$submit, {
    #   arithmetic.operation()
    # })
    #
    # # output of event reactive expression
    # output$arithmetic.operation <- renderText({
    #   text_reactive()
    # })
    
    # reactiveValues
    # text_reactive <- reactiveValues(
    #   text = "No text has been submitted yet."
    # )
    # 
    # # text output
    # output$arithmetic.operation.view2 <- renderText({
    #   text_reactive$text
    # })
    # output$arithmetic.operation <- renderText({
    #   arithmetic.operation()
    # })
  }
)