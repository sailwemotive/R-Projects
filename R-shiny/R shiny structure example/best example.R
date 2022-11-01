library(shiny)
library(shinyjs)

ui <- fluidPage(
  
  useShinyjs(),
  navbarPage("Test",
             tabPanel("Cohort",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput("cohort_file", "Choose CSV File",
                                    multiple = FALSE,
                                    accept = c("text/csv",
                                               "text/comma-separated-values,text/plain",
                                               ".csv")),
                          # Horizontal line ----
                          tags$hr(),
                          # Variable selection
                          selectInput('cohort_IDvar', 'ID', choices = ''),
                          selectInput('cohort_index_date', 'Index date', choices = ''),
                          selectInput('cohort_EOF_date', 'End of follow-up date', choices = ''),
                          selectInput('cohort_EOF_type', 'End of follow-up reason', choices = ''),
                          selectInput('cohort_Y_name', 'Outcome', choices = ''),
                          selectInput('cohort_L0', 'Baseline covariate measurements', choices = '', multiple=TRUE, selectize=TRUE),
                          # Horizontal line ----
                          tags$hr(),
                          disabled(
                            actionButton("set_cohort_button","Set cohort")
                          )
                          #actionButton("refresh_cohort_button","Refresh")
                        ),
                        mainPanel(
                          DT::dataTableOutput("cohort_table"),
                          tags$div(id = 'cohort_r_template')
                        )
                      )
             )
  )
)

server <- function(input, output, session) {
  
  ################################################
  ################# Cohort code
  ################################################
  
  cohort_data <- reactive({
    inFile_cohort <- input$cohort_file
    if (is.null(inFile_cohort))
      return(NULL)
    df <- read.csv(inFile_cohort$datapath, 
                   sep = ',')
    return(df)
  })
  
  rv <- reactiveValues(cohort.data = NULL)
  rv <- reactiveValues(cohort.id = NULL)
  rv <- reactiveValues(cohort.index.date = NULL)
  rv <- reactiveValues(cohort.eof.date = NULL)
  rv <- reactiveValues(cohort.eof.type = NULL)
  
  ### Creating a reactiveValue of the loaded dataset
  observeEvent(input$cohort_file, rv$cohort.data <- cohort_data())
  
  ### Displaying loaded dataset in UI
  output$cohort_table <- DT::renderDataTable({
    df <- cohort_data()
    DT::datatable(df,options=list(scrollX=TRUE, scrollCollapse=TRUE))
  })
  
  ### Collecting column names of dataset and making them selectable input
  observe({
    value <- c("",names(cohort_data()))
    updateSelectInput(session,"cohort_IDvar",choices = value)
    updateSelectInput(session,"cohort_index_date",choices = value)
    updateSelectInput(session,"cohort_EOF_date",choices = value)
    updateSelectInput(session,"cohort_EOF_type",choices = value)
    updateSelectInput(session,"cohort_L0",choices = value)
  })
  
  ### Creating selectable input for Outcome based on End of Follow-Up unique values
  observeEvent(input$cohort_EOF_type,{
    updateSelectInput(session,"cohort_Y_name",choices = unique(cohort_data()[,input$cohort_EOF_type]))
  })
  
  ### Series of observeEvents for creating vector reactiveValues of selected column
  observeEvent(input$cohort_IDvar, {
    rv$cohort.id <- cohort_data()[,input$cohort_IDvar]
  })
  observeEvent(input$cohort_index_date, {
    rv$cohort.index.date <- cohort_data()[,input$cohort_index_date]
  })
  observeEvent(input$cohort_EOF_date, {
    rv$cohort.eof.date <- cohort_data()[,input$cohort_EOF_date]
  })
  observeEvent(input$cohort_EOF_type, {
    rv$cohort.eof.type <- cohort_data()[,input$cohort_EOF_type]
  })
  
  ### ATTENTION: Following eventReactive not needed for example so commenting out
  ### Setting id and eof.type as characters and index.date and eof.date as Dates
  #cohort_data_final <- eventReactive(input$set_cohort_button,{
  #  rv$cohort.data[,input$cohort_IDvar] <- as.character(rv$cohort.id)
  #  rv$cohort.data[,input$cohort_index_date] <- as.Date(rv$cohort.index.date)
  #  rv$cohort.data[,input$cohort_EOF_date] <- as.Date(rv$cohort.eof.date)
  #  rv$cohort.data[,input$cohort_EOF_type] <- as.character(rv$cohort.eof.type)
  #  return(rv$cohort.data)
  #})
  
  ### Applying desired R function
  #set_cohort <- eventReactive(input$set_cohort_button,{
  #function::setCohort(data.table::as.data.table(cohort_data_final()), input$cohort_IDvar, input$cohort_index_date, input$cohort_EOF_date, input$cohort_EOF_type, input$cohort_Y_name, input$cohort_L0)
  #})
  
  ### R code template of function
  cohort_code <- eventReactive(input$set_cohort_button,{
    paste0("cohort <- setCohort(data = as.data.table(",input$cohort_file$name,"), IDvar = ",input$cohort_IDvar,", index_date = ",input$cohort_index_date,", EOF_date = ",input$cohort_EOF_date,", EOF_type = ",input$cohort_EOF_type,", Y_name = ",input$cohort_Y_name,", L0 = c(",paste0(input$cohort_L0,collapse=","),"))")
  })
  
  ### R code template output fo UI
  output$cohort_code <- renderText({
    paste0("cohort <- setCohort(data = as.data.table(",input$cohort_file$name,"), IDvar = ",input$cohort_IDvar,", index_date = ",input$cohort_index_date,", EOF_date = ",input$cohort_EOF_date,", EOF_type = ",input$cohort_EOF_type,", Y_name = ",input$cohort_Y_name,", L0 = c(",paste0(input$cohort_L0,collapse=","),"))")
  })
  
  ### Disables cohort button when "Set cohort" button is clicked
  observeEvent(input$set_cohort_button, {
    disable("set_cohort_button")
  })
  
  ### Disables cohort button if different dataset is loaded
  observeEvent(input$cohort_file, {
    disable("set_cohort_button")
  })
  
  ### This is where I run into trouble
  observeEvent({
    #input$cohort_file
    input$cohort_IDvar
    input$cohort_index_date
    input$cohort_EOF_date
    input$cohort_EOF_type
    input$cohort_Y_name
    input$cohort_L0
  }, {
    enable("set_cohort_button")
  })
  
  ### Inserts heading and R template code in UI when "Set cohort" button is clicked
  observeEvent(input$set_cohort_button, {
    insertUI(
      selector = '#cohort_r_template',
      ui = tags$div(id = "cohort_insertUI", 
                    h3("R Template Code"),
                    verbatimTextOutput("cohort_code"))
    )
  })
  
  ### Removes heading and R template code in UI when new file is uploaded or when input is changed
  observeEvent({
    input$cohort_file
    input$cohort_IDvar
    input$cohort_index_date
    input$cohort_EOF_date
    input$cohort_EOF_type
    input$cohort_Y_name
    input$cohort_L0
  }, {
    removeUI(
      selector = '#cohort_insertUI'
    )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
