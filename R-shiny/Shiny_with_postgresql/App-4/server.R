function(input, output) {
    
  all.data <- reactive({
    # Store the project ID
    projectid = "oval-plate-367310"
    
    # bq_auth(path ='./oval-plate-367310-0010e61f0cbb.json')
    
    ds <- bq_dataset("oval-plate-367310", "earthquake")
    
    tb <- bq_dataset_query(
      x = ds,
      query = "SELECT * FROM `earthquakes`",
      billing = 'oval-plate-367310'
    )
    dt <- bq_table_download(tb)
    
    # Convert to data.frame
    data.frame(dt)
  })
  
  output$mytable = DT::renderDataTable({
    all.data()
  })
}