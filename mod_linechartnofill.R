#' linechart UI Function
#'
#' @description A shiny Module to return line chart.
#'
#' @param id,input,output,session,df,opa Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_linechartnofill<- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(plotlyOutput(ns("linechart"), height = "200px"))
  )
}

#' linechart Server Function
#'
#' @noRd
mod_linechartnofillServer<- function(id, df, yaxistitle="", fill='tozeroy'){
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
            source = id
          )%>%
          layout(xaxis = list(title = "Datetime", color = "white"),
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

## To be copied in the UI
# mod_linechart_ui("linechart_ui_1")

## To be copied in the server
# callModule(mod_linechart_server, "linechart_ui_1")

