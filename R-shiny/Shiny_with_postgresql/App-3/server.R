function(input, output) {
    
  all.data <- reactive({
    # Get the data
    data <- GET(url = "http://127.0.0.1:7806/earthquakes_all", encode = "json", verbose())
    
    # Convert to data.frame
    data.frame(fromJSON(rawToChar(data$content)))
  })
  
  earthquake_id <- reactive({
    # Get the data
    data <- dbGetQuery(conn, glue("SELECT earthquake_ID FROM {table_name}"))
    
    # Disconnect from the DB
    # dbDisconnect(conn)
    
    # Convert to data.frame
    data.frame(data)
    
    #   # Get the data
    #   quakes <- dbGetQuery(conn, glue("SELECT * FROM earthquake WHERE richter >= {input$magSlider}"))
  })
  
  output$mytable = DT::renderDataTable({
    all.data()
  })
  
  output$SelectCategory <-renderUI({
    selectInput("SelectCategory", "Select Category",
                choices = earthquake_id()) 
  }) 
  
  output$status <- renderText({
    # Post the data
    data <- POST(url = glue("http://127.0.0.1:7806/in_earthquakes?in_focal_depth={input$focal_depth}&in_latitude={input$latitude}&in_longitude={input$longitude}&in_richter={input$richter}"), encode = "json", verbose())
    
    if(data$status_code == 200){
      paste("Data successfully inserted.")
    }
    else{
      paste("Something went wrong.")
    }
  })
  
}