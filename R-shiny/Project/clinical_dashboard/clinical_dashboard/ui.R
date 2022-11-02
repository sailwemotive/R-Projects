# Define UI for application that draws a histogram
ui <- fluidPage(
  # Internal CSS
  tags$head(tags$style(
    HTML('
         #sidebar {
            background-color: #20212400;
            border: None;
        }')
  )),
  
  # Application title
  titlePanel(
    tags$h3('Clinical Trials Design Tool')
  ),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(id="sidebar",
      wellPanel(
        fileInput("dataFile", "Choose CSV File",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv"))
      ),
      wellPanel(
        selectInput("state", "Choose a state:",
                    list(`East Coast` = list("NY", "NJ", "CT"),
                         `West Coast` = list("WA", "OR", "CA"),
                         `Midwest` = list("MN", "WI", "IA"))
        ),
        textOutput("result")
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(      
      wellPanel(
        DT::dataTableOutput("allData")
        ),
      # fluidRow(
      #   column(8,
      #          wellPanel(
      #            plotOutput("distPlot")
      #          ))
      # )
    )
  )
)