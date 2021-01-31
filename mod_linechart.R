
mod_linechart<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("linechart"), height = "200px"))
  )
}

mod_linechartServer<- function(id, df, yaxistitle="", fill='tozeroy'){
  moduleServer(
    id,
    function(input,output,session){
      output$linechart<- renderPlotly({
        df%>%
          plot_ly(
            x=~datetime,
            y=~value,
            color = ~name,
            type = 'scatter', 
            mode = 'lines',
            line= list(width = 5),
            fill = 'tozeroy',
            source = id
          )%>%
          layout(xaxis = list(title = "Months", color = "white"),
                 yaxis = list(title = yaxistitle, color = "white"),
                 plot_bgcolor = 'transparent',
                 paper_bgcolor = 'transparent',
                 legend = list(orientation = 'h'),
                 dragmode = "select"
          )%>% config(displayModeBar = FALSE)
      })
      
      selectedrange<- reactive({
        d<-event_data("plotly_brushed", source = id)
        return(d$x)
      })
      
      return(selectedrange())
      
    }
  )
}


