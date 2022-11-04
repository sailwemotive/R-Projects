#* @Path app/view/chart.R
#* @Description Receiving data from main and presenting in echarts4r.

box::use(
  echarts4r,
  shiny[moduleServer, NS, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    echarts4r$echarts4rOutput(ns("chart"))
  )
}

#' @export
server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$chart <- echarts4r$renderEcharts4r(
      data |>
        echarts4r$group_by(Species) |>
        echarts4r$e_chart(x = Year) |>
        echarts4r$e_line(Population) |>
        echarts4r$e_x_axis(Year) |>
        echarts4r$e_tooltip()
    )
  })
}