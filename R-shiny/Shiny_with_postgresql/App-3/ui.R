fluidPage(
  mainPanel(
    # Application title
    titlePanel(
      tags$h1("Earthquakes Data"),
    ),
    
    fluidRow(
      column(8,
             DT::dataTableOutput("mytable")
      ),
      column(4,
             wellPanel(
               uiOutput("SelectCategory"),
               textInput("focal_depth", label = "Enter Focal Depth"),
               textInput("latitude", label = "Enter Latitude"),
               textInput("longitude", label = "Enter Longitude"),
               textInput("richter", label = "Enter Richter"),
               submitButton(text = "Add Findings", icon = NULL, width = NULL)
             ),
             wellPanel(
               textOutput("status")
             )
      )
    )
  )
)