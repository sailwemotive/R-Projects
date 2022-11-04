#* @Path app/view/datatable.R
#* @Description Receiving data from main and presenting in datatable.

box::use(
  DT[dataTableOutput, renderDataTable],
  shiny[moduleServer, fluidPage, mainPanel, NS]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    mainPanel(
      DT::dataTableOutput(ns("mytable"))
    )
  )
}

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$mytable = DT::renderDataTable({
      data
    })
  })
}