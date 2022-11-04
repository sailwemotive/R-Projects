#* @Path app/view/table.R
#* @Description Receiving data from main and presenting in reactable.

box::use(
  reactable,
  shiny[moduleServer, NS, tagList]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    reactable$reactableOutput(ns("table"))
  )
}

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$table <- reactable$renderReactable(
      reactable$reactable(data)
    )
  })
}