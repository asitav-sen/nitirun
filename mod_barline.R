# Module for creating horizontal bar chart with line
mod_barscatterchart<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("barscatplot"), height = "200px"))
  )
}

mod_barscatterchartServer<- function(id, df, title="", name1="", name2=""){
  moduleServer(
    id,
    function(input,output,session){
      output$barscatplot<- renderPlotly({
        df%>%
          plot_ly(
            x =  ~ value1,
            y =  ~ reorder(name,-value1),
            type = "bar",
            opacity = 0.7,
            name = name1
          ) %>%
          add_trace(
            x= ~ value2,
            type="scatter",
            size=4,
            name=name2
          )%>%
          layout(
            #title= title,
            legend = list(orientation = 'h'),
            xaxis = list(title = title, color = "white"),
            yaxis = list(title = "", color = "white"),
            plot_bgcolor = 'transparent',
            paper_bgcolor = 'transparent'
          ) %>% config(displayModeBar = FALSE)
      })
    }
  )
}
