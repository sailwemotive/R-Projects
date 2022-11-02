fluidPage(
  
  uiOutput("questionnaire_section"),
  actionButton("button", "Submit"),
  
  tags$hr(),
  tableOutput("responses"), 
  tags$hr(),
  
)