
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
            paper_bgcolor = 'transparent',
            # images = list(
            #   list(source = "faviconwhite.png",
            #        xref = "paper",
            #        yref = "paper",
            #        x = 0.9, y = 0.8, 
            #        sizex = 0.3, sizey = 0.3,
            #        opacity= 0.7,
            #        xref = "paper", yref = "paper", 
            #        xanchor = "left", yanchor = "bottom"
            #   ))
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


