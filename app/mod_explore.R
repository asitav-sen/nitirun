
mod_exploremodule<- function(id){
  ns<-NS(id)
  fluidRow(
    h2("Summary of events"),
    box(
      width = 12,
      fluidRow(
        #column(width = 1),
        column(width = 4,
               radioButtons("ctype","Make a selection", 
                            choices = c("failures","replacements","total"),
                            selected = "failures",
                            inline=T,
                            choiceNames = c("Failures","Scheduled Replacements", "Total"))),
        column(width = 8,
               mod_descblock(ns("tseries")))
             )
    ),
    shinydashboardPlus::box(
      title = "Monthly progress",
    #background ="black",
    collapsible = F,
    width = 6,
    fluidRow(
             mod_linechart(ns("timeserieschart"))
    )
    
  ),
  shinydashboardPlus::box(
    title = "By Component",
    #background ="black",
    collapsible = F,
    width = 6,
    fluidRow(
      mod_mainchart(ns("bycomp"))
    )
  )
)
}

mod_exploremoduleServer<- function(id, df, dfdesc, bycompdata, yaxistitle="Count"){
  moduleServer(
    id,
    function(input,output,session){
      mod_linechartServer("timeserieschart",df, yaxistitle)
      mod_descblockServer("tseries", dfdesc)
      #mod_descblockServer("descbycomp", bycompdesc)
      mod_mainchartServer("bycomp", bycompdata)
      clickoutput<-reactive({
        mod_mainchartServer("bycomp", bycompdata)
      })
      return(clickoutput())
    }
  )
}
