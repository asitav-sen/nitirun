mod_descblock<- function(id){
  ns<-NS(id)
  tagList(
  uiOutput(ns("descblocks")))
}

mod_descblockServer<- function(id, dfdesc){
  moduleServer(
    id,
    function(input,output,session){
      
      output$descblocks <- renderUI({
        fluidRow(
          column(
            width = 4,
            descriptionBlock(
              number = paste0(round((dfdesc$value[1]-dfdesc$value[2])*100/dfdesc$value[2],2),"%"), 
              numberColor = ifelse((dfdesc$value[1]-dfdesc$value[2])*100/dfdesc$value[2]>0, "red","green"), 
              numberIcon = icon(paste0(ifelse((dfdesc$value[1]-dfdesc$value[2])*100/dfdesc$value[2]>0,"caret-up","caret-down"))),
              header = round(dfdesc$value[1],2), 
              text = "Current Month", 
              rightBorder = T,
              marginBottom = T
            )
          ),
          column(
            width = 4,
            descriptionBlock(
              number = paste0(round((dfdesc$avgval[1]-dfdesc$avgval[2])*100/dfdesc$avgval[2],2),"%"), 
              numberColor = ifelse((dfdesc$avgval[1]-dfdesc$avgval[2])*100/dfdesc$avgval[2]>0, "red","green"), 
              numberIcon = icon(paste0(ifelse((dfdesc$avgval[1]-dfdesc$avgval[2])*100/dfdesc$avgval[2]>0,"caret-up","caret-down"))),
              header = round(dfdesc$avgval[1],2), 
              text = "Cumulative Average", 
              rightBorder = T,
              marginBottom = T
            )
          ),
          column(
            width = 4,
            descriptionBlock(
              number = paste0(round((dfdesc$cumval[1]-dfdesc$cumval[2])*100/dfdesc$cumval[2],2),"%"), 
              numberColor = ifelse((dfdesc$cumval[1]-dfdesc$cumval[2])*100/dfdesc$cumval[2]>0, "red","green"), 
              numberIcon = icon(paste0(ifelse((dfdesc$cumval[1]-dfdesc$cumval[2])*100/dfdesc$cumval[2]>0,"caret-up","caret-down"))),
              header = round(dfdesc$cumval[1],2), 
              text = "Cumulative Total", 
              rightBorder = T,
              marginBottom = T
            )
          )
        )
      })
    }
  )
}
