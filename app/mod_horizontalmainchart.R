
mod_horizontalmainchart<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("horizontalchart"), height = "200px"))
  )
}


mod_horizontalmainchartServer<- function(id, df, title=""){
  moduleServer(
    id,
    function(input,output,session){
      output$horizontalchart<- renderPlotly({
        df%>%
          plot_ly(
            x =  ~ value,
            y =  ~ reorder(name,-value),
            type = "bar",
            opacity = 0.7,
            source = id
          ) %>%
          layout(
            #title= title,
            xaxis = list(title = title, color = "white"),
            yaxis = list(title = "", color = "white"),
            plot_bgcolor = 'transparent',
            paper_bgcolor = 'transparent'#,
            #dragmode = "select"
          ) %>% config(displayModeBar = FALSE)
      })
      
      barclick<- reactive({
        d<- event_data("plotly_click", source = id)
        return(d$y)
      })
      return(barclick())
    }
  )
}


