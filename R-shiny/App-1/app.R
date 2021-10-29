library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel(
    strong("Introducing Shiny")
  ),
  sidebarLayout(
    sidebarPanel(
      div(
        h1(
          strong("R Installation ")
        ),
        p(
          h5(
            strong(
              "Shiny is available on CRAN, So you can install it in the usual way from your R console:",
              br(),
              code(
                span("install.packages('shiny')", style="color:red")
              )
            )
          )
        ),
        br(),br(),br(),
        img(src = "r-studio.png", height = 90, width = 260,),
        h5(
          "Shiny is a product of",
          span("RStudio", style="color:blue")
        )
      )
    ),
    mainPanel(
      h2("Introduction", align = "left"),
      p(
        "Shiny is an open source R package that provides an elegant and powerful web framework for building web applications using R. Shiny helps you turn your analyses into interactive web applications without requiring HTML, CSS, or JavaScript knowledge.",
        br(),
        strong(
          a("Read more", href="https://www.rstudio.com/products/shiny/")
        )
      ),
      p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
      strong("strong() makes bold text."),
      em("em() creates italicized (i.e, emphasized) text."),
      br(),
      code("code displays your text similar to computer code"),
      div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
      br(),
      p("span does the same thing as div, but it works with",
        span("groups of words,", style = "color:blue"),
        "that appear inside a paragraph."),
      br(),
      img(src = "r-studio.png", height = 140, width = 400)
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "orange",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)