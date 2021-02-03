
mod_info <- function(id){
  ns<-NS(id)
  tagList(
    withSpinner(infoBoxOutput(ns("infobox"), width=3))
  )
}


mod_infoServer<- function(id, value, title, colour, icon, subtitle=""){
  moduleServer(
    id,
    function(input,output,session){
      output$infobox<- renderInfoBox({
        infoBox(
          title = title,
          value = value,
          icon = icon(icon),
          color = colour,
          subtitle = subtitle
        )
      })
    }
  )
}


