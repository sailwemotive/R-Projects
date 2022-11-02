fluidPage(
  sidebarLayout(
    sidebarPanel(
      helpText(),
      radioButtons('format', 'Document format', c('PDF', 'Word'),
                   inline = TRUE),
      downloadButton('downloadReport')
    ),
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2"),
      plotOutput("plot3"),
      DT::dataTableOutput("mytable")
    )
  )
)