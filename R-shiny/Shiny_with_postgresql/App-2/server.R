function(input, output) {
  
  # Description: scatter plot
  # x axis: Corruption.Perceptions.Index
  # y axis: Human.Development.Index
  # output ID: plot1
  # return: ggplot
  output$plot1 <- renderPlot({
    ggplot(cnf.dev.df, aes(x = Corruption.Perceptions.Index,
                           y = Human.Development.Index)) + 
      geom_point(size=1)
  })
  
  # Description: scatter plots based on regions which HDI rank less than equals to 20.
  # x axis: Corruption.Perceptions.Index
  # y axis: Human.Development.Index
  # output ID: plot2
  # return: ggplot
  output$plot2 <- renderPlot({
    ggplot(cnf.dev.df, aes(x = Corruption.Perceptions.Index,
                           y = Human.Development.Index, 
                           color=Region)) + 
      geom_point(size=3, shape=1,stroke=1.5) +
      geom_smooth(method=lm, se=FALSE, col='red', size=1) + 
      geom_text(data = cnf.dev.df,
                aes(label= subset(cnf.dev.df, HDI.Rank<=20)),
                label= cnf.dev.df$Country,
                nudge_x=0.45, nudge_y=0.1,
                check_overlap=T
      ) + 
      ggtitle("Sail kargutkar") + 
      xlab("Corruption Perceptions") + 
      ylab("Human Development") + 
      labs(caption = "Human Development increasing along with corruption.") + 
      theme_minimal() + 
      theme(legend.position = "top")
  })
  
  # Description: boxplot fill with regions
  # x axis: Corruption.Perceptions.Index
  # y axis: Human.Development.Index
  # output ID: plot3
  # return: boxplot
  output$plot3 <- renderPlot({
    ggplot(cnf.dev.df, aes(x = Corruption.Perceptions.Index, y = Human.Development.Index, fill = Region)) + 
      geom_boxplot() +
      stat_summary(fun = "mean", geom = "point", shape = 8,
                   size = 2, color = "white")
  })
  
  # Description: rendering datatables for corruption dat
  # output ID: mytable
  # return: dataframe 
  output$mytable = DT::renderDataTable({
    cnf.dev.df
  })
  
  # Description: Code to export rmd file into formats like pdf and word.
  # output: Download PDF or Word file.
  # output ID: downloadReport
  # return: Download File
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', Word = 'docx'
      ))
    },
    
    content = function(file) {
      src <- normalizePath('report.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'report.Rmd', overwrite = TRUE)
      
      library(rmarkdown)
      out <- render('report.Rmd', switch(
        input$format,
        PDF = pdf_document(), Word = word_document()
      ))
      file.rename(out, file)
    }
  )
  
}