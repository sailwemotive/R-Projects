# load shiny first to avoid any conflict messages later
library(shiny)

# Don't run apps when knitting
shinyApp <- function(...) {
  if (isTRUE(getOption("knitr.in.progress"))) {
    invisible()
  } else {
    shiny::shinyApp(...)
  }
}