library(shiny)

setwd('C:/MyFiles/Learning/git/R-Projects/R-shiny/R shiny structure example')

ui <- fluidPage(
  downloadButton('download')
)

server <- function(input, output) {
  output$download <- downloadHandler(
    filename = "listing.pdf",
    content = function(f) {
      # Create a new empty environment
      # This allows us to pass in only the relevant variables into the report
      e <- new.env()
      # Pass two data sets into our template
      e$datasets <- list(mtcars, iris)
      # Render the document
      rmarkdown::render('./template.Rmd',
                        output_format = rmarkdown::pdf_document(),
                        output_file=f,
                        envir = e)
    }
  )
}

shinyApp(ui = ui, server = server)
