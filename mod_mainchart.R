
mod_mainchart<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("barchart"), height = "200px"))
  )
}


mod_mainchartServer<- function(id, df, title=""){
  moduleServer(
    id,
    function(input,output,session){
      output$barchart<- renderPlotly({
        df%>%
          plot_ly(
            x =  ~ reorder(name,-value),
            y =  ~ value,
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
        return(d$x)
        # names<- reorder(df$name,-df$value)
        # print(clickdata$x)
        # names[clickdata$x]
      })
      return(barclick())
    }
    

    
  )
}


