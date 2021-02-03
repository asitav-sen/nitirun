mod_gauge<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("gaugechart"), height = "150px"))
  )
}

mod_gaugeServer<- function(id, value, title="", lastvalue, maxval=500, rangeval1=250, rangeval2=400, threshold= 490) {
  moduleServer(
    id,
    function(input,output,session){
      output$gaugechart<- renderPlotly({
        plot_ly(
          domain = list(x = c(0, 1), y = c(0, 1)),
          value = value,
          title = "",#list(text = title),
          type = "indicator",
          mode = "gauge+number+delta",
          delta = list(reference = lastvalue),
          gauge = list(
            axis =list(range = list(NULL, maxval)),
            steps = list(
              list(range = c(0, rangeval1), color = "lightgray"),
              list(range = c(rangeval1, rangeval2), color = "gray")),
            threshold = list(
              line = list(color = "red", width = 4),
              thickness = 0.75,
              value = threshold)))%>%
          layout(
            #title= title,
            #margin = list(l=10,r=5),
            xaxis = list(title = title, color = "white"),
            yaxis = list(title = "", color = "white"),
            plot_bgcolor = 'transparent',
            paper_bgcolor = 'transparent',
            font = list(color = "white")
            #dragmode = "select"
          ) %>% config(displayModeBar = FALSE)
      })
    }
      
  )
}