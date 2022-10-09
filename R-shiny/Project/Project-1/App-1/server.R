library("shiny")

shinyServer(
  function(input, output){
    
    output$arithmetic.operation <- renderText({
      if(input$arithmetic.operation == "Addition"){
        input$number1 + input$number2
      }
      else if(input$arithmetic.operation == "Subtraction"){
        input$number1 - input$number2
      }
      else if(input$arithmetic.operation == "Multiplication"){
        input$number1 * input$number2
      }
      else if(input$arithmetic.operation == "Division"){
        input$number1 / input$number2
      }
    }) 
  }
)