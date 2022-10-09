library("shiny")

shinyUI(
  fluidPage(
    titlePanel(
      title = "This is title."
    ),
    fluidRow(
      column(4,
             wellPanel(
               h4("Calculator"), 
               selectInput("arithmetic.operation", "Select arithmetic operation", c("Addition", "Subtraction", "Division", "Multiplication")),
               numericInput("number1", "Enter first number", ""),
               numericInput("number2", "Enter second number", "")
             )       
      ),
      column(8,
             h3("Output"),
             textOutput("arithmetic.operation")
      )
    )
  )
)