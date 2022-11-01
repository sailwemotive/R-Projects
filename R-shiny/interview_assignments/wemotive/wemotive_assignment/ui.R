fluidPage(
  
  # Below to make a select box 
  selectInput("select", label = h4("Question 1"), 
              choices = list("Choice 1" = 1, "Choice 2" = 2, 
                             "Choice 3" = 3, "Choice 4" = 4), 
              selected = 1),
  
  uiOutput("period_cutpoints"),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)