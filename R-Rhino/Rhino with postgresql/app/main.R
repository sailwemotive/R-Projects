box::use(
  httr[GET, POST, verbose],
  jsonlite[fromJSON],
  glue[glue],
  RPostgres[Postgres],
  DBI[dbConnect, dbGetQuery],
  shinydashboard[dashboardPage, dashboardHeader, dashboardSidebar, dashboardBody, box, tabItems, tabItem, sidebarMenu, menuItem],
  shiny[moduleServer, NS, renderText, reactive, textOutput, fluidPage, plotOutput, sliderInput, mainPanel, titlePanel, tags, h1, fluidRow, column, wellPanel, uiOutput, textInput, submitButton, renderUI, selectInput, h2]
)
box::use(
  app/view/chart,
  app/view/table,
  app/view/datatable
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
    dashboardHeader(title = "Dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard"),
        menuItem("Stats", tabName = "stats")
      )
    ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
                fluidRow(
                  table$ui(ns("table"))
                )
        ),
        
        # Second tab content
        tabItem(tabName = "stats",
                # Application title
                titlePanel(
                  tags$h1(textOutput(ns("message"))),
                ),
                
                fluidRow(
                  column(8,
                         datatable$ui(ns("datatable"))
                  ),
                  column(4,
                         wellPanel(
                           uiOutput(ns("SelectCategory")),
                           textInput(ns("focal_depth"), label = "Enter Focal Depth"),
                           textInput(ns("latitude"), label = "Enter Latitude"),
                           textInput(ns("longitude"), label = "Enter Longitude"),
                           textInput(ns("richter"), label = "Enter Richter"),
                           submitButton(text = "Add Findings", icon = NULL, width = NULL)
                         ),
                         wellPanel(
                           textOutput(ns("status"))
                         )
                  )
                ),
                
                fluidRow(
                  column(6,
                         chart$ui(ns("chart"))
                  ),
                  column(6,
                         # table$ui(ns("table"))
                  )
                )
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$message <- renderText("Earthquakes Data")
    
    db <- "earthquakes"
    db_host <- "localhost"
    db_port <- "5432"
    db_user <- "postgres"
    db_pass <- "root"

    conn <- dbConnect(
      RPostgres::Postgres(),
      dbname = db,
      host = db_host,
      port = db_port,
      user = db_user,
      password = db_pass
    )
    
    #* @Description Fetching data from postgre DB using query.
    all.data.postgre.query <- reactive({
      # Get the data
      data <- dbGetQuery(conn, glue("SELECT focal_depth, latitude, longitude, richter FROM earthquake"))
      
      # Convert to data.frame
      data.frame(data)
    })
    
    #* @Description Fetching data through Plumber API.
    all.data.plumber.api <- reactive({
      # Get the data
      data <- GET(url = "http://127.0.0.1:8135/earthquakes_all", encode = "json", verbose())
  
      # Convert to data.frame
      data.frame(fromJSON(rawToChar(data$content)))
    })
    
    #* @Description Fetching only earthquakes_ID column through Plumber API.
    earthquakes.ids.plumber.api <- reactive({
      # Get the data
      data <- GET(url = "http://127.0.0.1:8135/earthquakes_ids", encode = "json", verbose())
      
      # Convert to data.frame
      data.frame(fromJSON(rawToChar(data$content)))
    })
    
    #* @Description Fetching inbuild rhino data.
    chart.data <- rhino::rhinos
    
    table$server("table", data = all.data.postgre.query())
    datatable$server("datatable", data = all.data.plumber.api())
    chart$server("chart", data = chart.data)
    
    output$SelectCategory <- renderUI({
      selectInput("SelectCategory", "Select Category",
                  choices = earthquakes.ids.plumber.api()) 
    }) 
    
    #* @Description Inserting data into database through Plumber API.
    output$status <- renderText({
      # Post the data
      data <- POST(url = glue("http://127.0.0.1:8135/in_earthquakes?in_focal_depth={input$focal_depth}&in_latitude={input$latitude}&in_longitude={input$longitude}&in_richter={input$richter}"), encode = "json", verbose())
      
      if(data$status_code == 200){
        paste("Data successfully inserted.")
      }
      else{
        paste("Something went wrong.")
      }
    })
  })
}
