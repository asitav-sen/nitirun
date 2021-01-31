mod_exploremodule<- function(id){
    ns<-NS(id)
    fluidPage(
  fluidRow(
    shinydashboardPlus::box(
      width = 12,
      title = "Summary of noticable events",
    fluidRow(
      column(width = 8,
             mod_descblock(ns("tseries"))
             ),
      column(width = 4,
             radioButtons(ns("ctype"),"Make a selection", 
                          choices = c("failures","replacements","total"),
                          selected = "failures",
                          inline=T)
             )
    )
    ),
    shinydashboardPlus::box(
      title = "Monthly events",
      #background ="black",
      collapsible = F,
      width = 6,
      footer = "Click and drag to select desired range",
      fluidRow(
        mod_linechart(ns("timeserieschart"))
      )
      
    ),
    shinydashboardPlus::box(
      title = textOutput(ns("compstitle")),
      #background ="black",
      collapsible = F,
      width = 6,
      footer = "Click on any bar to select data of corresponding component",
      fluidRow(
        mod_mainchart(ns("bycomp"))
      )
    )
  ),
  fluidRow(
    shinydashboardPlus::box(
      title = textOutput(ns("bymodelplottitle")),
      #background ="black",
      collapsible = F,
      footer = "Click on any bar to select data of corresponding model",
      width = 6,
      fluidRow(
        mod_horizontalmainchart(ns("bymodelchart"))
      )
      
    ),
    shinydashboardPlus::box(
      title = textOutput(ns("bymacplottitle")),
      #background ="black",
      collapsible = F,
      width = 6,
      footer = "Numbers in x axis are machine serial numbers",
      fluidRow(
        mod_mainchart(ns("bymachineplot"))
      )
    )
  )
  
)
  }

mod_exploreServer <- function(id, df=timeseriesdata, df2= trainfileset){
  moduleServer(
    id,
    function(input,output,session){
      
      # data for time series
      timesdata<- reactive({
        df%>%
          filter(name==input$ctype)
      })
      
      observeEvent(input$ctype,{
        mod_linechartServer("timeserieschart",timesdata(), yaxistitle="Count")
      })
      # data for time series description box
      timesdescdata<- reactive({
        timesdata()%>%
          slice_max(order_by = datetime, n=2)
      })
      
      # Plot time series
      observeEvent(input$ctype,{
        mod_descblockServer("tseries", timesdescdata())
      })
      
      # Define daterange from linechart selection
      daterange<- reactive({
        if(is.null(mod_linechartServer("timeserieschart",timesdata()))){
          unique(trainfileset$datetime)
        } else (ymd_hms(mod_linechartServer("timeserieschart",timesdata())))
        })
      
      # Title for comp plot
      output$compstitle<- renderText({
        paste0("By component (events between ", round_date(min(daterange()), "month"), " & ", round_date(max(daterange()), "month"),")")
      })
      
      # Define data for by component chart
      # Define the basic data
      bycompbasic<- reactive({
        switch(input$ctype,
               failures = filter(df2, failure==1),
               replacements = filter(df2, failure==0),
               total = df2)
      })
      
      # filter and group + summarize
      bycompdata<- reactive({
       
        bycompbasic()%>%
          filter(datetime >= min(daterange()))%>%
          filter(datetime<=max(daterange()))%>%
          group_by(comp)%>%
          summarise(value=n())%>%
          ungroup()%>%
          rename(name=comp)
      })
      
      
      observeEvent(c(input$ctype, daterange()),{
        mod_mainchartServer("bycomp", bycompdata())
      })
      
      # Show error if clicked outside the plot
      observeEvent(daterange(), {
        if(is.na(min(daterange())) | is.na(max(daterange()))){
        showModal(modalDialog(
          title = "Sorry! I am not that smart yet.",
          "Can you please keep your selecting within the plot area?",
          easyClose = TRUE,
          footer = "Click anywhere outside to close"
        ))
        }
      })
      
      #mod_descblockServer("descbycomp", bycompdesc)
      
      # dataset for by model
      
      compselect<-reactive({
        if(is.null(mod_mainchartServer("bycomp", bycompdata()))) {
          "comp2"
        } else {
          a<-mod_mainchartServer("bycomp", bycompdata())
          a
        }
        
      })
      
      # filtered data for the plot
      bymodeldata<- reactive({
        bycompbasic()%>%
          filter(comp %in% compselect())%>%
          group_by(model)%>%
          summarise(value=n())%>%
          ungroup()%>%
          rename(name=model)
      })
      
      # title for by model plot
      
      output$bymodelplottitle<- renderText({
        paste0("Events in ",compselect(), " by model")
      })
      
      # by model plot
      observeEvent(c(input$ctype,compselect()),
        {
        mod_horizontalmainchartServer("bymodelchart",bymodeldata())
      })
     
      # by machine no. data
      
      modelselect<-reactive({
        if(is.null(mod_horizontalmainchartServer("bymodelchart", bymodeldata()))) {
          "model1"
        } else {
          a<-mod_horizontalmainchartServer("bymodelchart", bymodeldata())
          a
        }
        
      })
      
      bymachinedata<- reactive({
        # print("modelselec")
        # print(modelselect())
        bycompbasic()%>%
          filter(comp %in% compselect())%>%
          filter(model %in% modelselect())%>%
          group_by(machineID)%>%
          summarise(value=n())%>%
          ungroup()%>%
          rename(name=machineID)
      })
      
      # by machine no. plot
      observeEvent(c(input$ctype, compselect(), bymachinedata()),
        {
        mod_mainchartServer("bymachineplot",bymachinedata())
      })
      
      # title for by machine plot
      
      output$bymacplottitle<- renderText({
        paste0("Events in ",modelselect(), " by machine")
      })
    }
  )
}
