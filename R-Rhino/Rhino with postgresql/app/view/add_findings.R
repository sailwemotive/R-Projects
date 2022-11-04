#* @Path app/view/add_findings.R
#* @Description Forms to add findings

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