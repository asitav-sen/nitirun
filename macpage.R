mod_macmodule<- function(id){
  ns<-NS(id)
  fluidPage(
    tags$head(includeHTML("google.html")),
    tags$head(includeHTML("hotjar.html")),
    fluidRow(
      box(
        width = 12,
        column(width = 8,
               h3("Telemetry data")),
        column(width = 4)
      ),
      box(
        width = 12,
        column(width = 3,
               p("Parameter Value", align="center"),
               descriptionBlock(
                 header = textOutput(ns("macvalue")),
                 text = textOutput(ns("modvalue")),
                 rightBorder = TRUE
               )),
      column(width = 3,
             p("Age", align="center"),
             descriptionBlock(
               header = textOutput(ns("macage")),
               text = textOutput(ns("modage")),
               rightBorder = TRUE
             )),
      column(width = 3,
             selectizeInput(ns("mac_no"),"Select machine no.", choices = seq(1:100),selected = 1)),
        column(width = 3,
               selectizeInput(ns("ptype"), "Select Parameter", choices = c("Voltage", "Pressure", "Rotation", "Vibration"),
                              selected = "Voltage"))
      )
    ),
    fluidRow(
      column(
        width = 5,
        withSpinner(uiOutput(ns("timeline")))
      ),
      column(
        width = 7,
       # box(
          #background ="black",
          #collapsible = F,
          #width = 12,
          fluidRow(
            column(
              width = 6,
              shinydashboardPlus::box(
                title = "Voltage",
                width = 12,
                mod_gauge(ns("voltage"))
              ),
              shinydashboardPlus::box(
                title = "Pressure",
                width = 12,
                mod_gauge(ns("pressure"))
              )
            ),
            column(
              width = 6,
              shinydashboardPlus::box(
                title = "Rotation",
                width = 12,
                mod_gauge(ns("rotation"))
              ),
              shinydashboardPlus::box(
                title = "Vibration",
                width = 12,
                mod_gauge(ns("vibration"))
              )
            )
          )
        #)
        ,
        shinydashboardPlus::box(
          title = "Hourly values",
          width = 12,
        mod_linechartnofill(ns("machineparameter"))),
        shinydashboardPlus::box(
          title = "Comparison: failure with average of the model",
          width = 12,
          mod_barscatterchart(ns("macfail"))
        ),
        shinydashboardPlus::box(
          title = "Comparison: replacements with average of the model",
          width = 12,
        mod_barscatterchart(ns("macrep"))
        )
        )
      )
    )
}

mod_macmoduleServer <- function(id, telemetry.data = telemetry, trainfile = trainfileset, modfairep.data=modfairep){
  moduleServer(
    id,
    function(input,output,session){
      
      # data for gaugechart
      gaugedatabase<-
        telemetry.data%>%
        pivot_longer(c(3:6), "parameter")%>%
        group_by(machineID,parameter)%>%
        slice_max(order_by=datetime,n=2)%>%
        ungroup()
      
      # for voltage, data and graph
      voltval<- reactive({
        gaugedatabase%>%
          filter(parameter=="volt")%>%
          filter(machineID==input$mac_no)
      })
      
      observeEvent(input$mac_no,{
        mod_gaugeServer("voltage", value=as.integer(voltval()[1,4]), title="Voltage", lastvalue= as.integer(voltval()[2,4]), maxval=200, 
                        rangeval1=150, rangeval2=175, threshold= 190)
      })
      
      # pressure
      pressval<- reactive({
        gaugedatabase%>%
          filter(parameter=="pressure")%>%
          filter(machineID==input$mac_no)
      })
      
      observeEvent(input$mac_no,{
        
        mod_gaugeServer("pressure", value=as.integer(pressval()[1,4]), title="Pressure", lastvalue= as.integer(pressval()[2,4]), maxval=200, 
                        rangeval1=100, rangeval2=160, threshold= 190)
      })
      
      # vibration
      
      vibval<- reactive({
        gaugedatabase%>%
          filter(parameter=="vibration")%>%
          filter(machineID==input$mac_no)
      })
      
      observeEvent(input$mac_no,{
        mod_gaugeServer("vibration", value=as.integer(vibval()[1,4]), title="Vibration", lastvalue= as.integer(vibval()[2,4]), maxval=100, 
                        rangeval1=50, rangeval2=75, threshold= 90)
      })
      
      # rotation
      
      rotval<- reactive({
        gaugedatabase%>%
          filter(parameter=="rotate")%>%
          filter(machineID==input$mac_no)
      })
      
      observeEvent(input$mac_no,{
        mod_gaugeServer("rotation", value=as.integer(rotval()[1,4]), title="Rotation", lastvalue= as.integer(rotval()[2,4]), maxval=720, 
                        rangeval1=360, rangeval2=550, threshold= 700)
      })
      
      # selected parameter
      parat <-
        reactive({
          ifelse(
            input$ptype == "Voltage",
            "volt",
            ifelse(
              input$ptype == "Pressure",
              "pressure",
              ifelse(input$ptype == "Vibration", "vibration", "rotate")
            )
          )
        })
      # data based on parameter
      parad <- reactive({
        telemetry.data %>% filter(machineID == input$mac_no)%>%
          pivot_longer(c(3:6)) %>%
          filter(name == parat())%>%
          mutate(events=round(value,2))
      })
      
      observeEvent(c(input$mac_no,input$ptype),{mod_linechartnofillServer("machineparameter", parad(), fill="transparent")})
      
      # failure by component of the selected machine
      macfaildata<- reactive({
        trainfile%>%
          filter(machineID==input$mac_no)%>%
          group_by(comp)%>%
          summarise(value=sum(failure))%>%
          ungroup()%>%
          rename(name=comp)
      })
      
      # Model of selected machine
      param<-reactive({
        unique(filter(trainfile,machineID==input$mac_no)$model)
      })

      modfaifaildata<- reactive({
        modfairep.data%>%
          filter(model==param())%>%
          rename(name=comp)%>%
          inner_join(macfaildata(), by=c("name"))%>%
          rename(value1=value, value2=avgfailure)
      })
      
      
      observeEvent(input$mac_no,{mod_barscatterchartServer("macfail",modfaifaildata(), "Failures","Machine","Model Avg.")})
      
      # replacement by component for selected machine
      macrepdata<- reactive({
        trainfile%>%
          filter(machineID==input$mac_no)%>%
          group_by(comp)%>%
          summarise(value=n())%>%
          ungroup()%>%
          rename(name=comp)
      })
      
      
      
      modfairepdata<- reactive({
        modfairep%>%
          filter(model==param())%>%
          rename(name=comp)%>%
          inner_join(macrepdata(), by=c("name"))%>%
          rename(value1=value, value2=avgrepl)
      })
      
      observeEvent(input$mac_no,{mod_barscatterchartServer("macrep",modfairepdata(), "Replacements","Machine","Model Avg.")})
      
      
      output$timeline <- renderUI({
        df<-trainfile%>%
          filter(machineID==input$mac_no)%>%
          filter(failure==1)%>%
          mutate(datetime=floor_date(datetime,unit = "day"))%>%
          arrange(desc(datetime))
        timelineBlock(
          reversed = TRUE,
          timelineEnd(color = "red"),
          lapply(split(df, df$datetime), function(x) {
            list(
              timelineLabel(x$datetime[1], color = "navy"),
              lapply(x$comp, function(title) 
                mytimeItem(
                  icon = "gears",
                  color = "olive",
                  title,
                  timelineItemMedia(image = switch(title,
                                                   comp1= "https://thiruvananthapuramupdates.files.wordpress.com/2012/01/1.jpg?resize=150%2C150",
                                                   comp2= "https://i0.wp.com/spacerockethistory.com/wp-content/uploads/2014/01/mariner04-150x150.gif?resize=150%2C150",
                                                   comp3= "https://www.edcparts.com/wp-content/uploads/2020/11/97644l_161245-Angulation-150x150-2.jpg?resize=150%2C150" ,
                                                   comp4= "https://ussrwatch.net/var/images/product/75.90/front-03_1.jpg" ))
                )
              )
            )}
          )
        )
      })
      
      
      # text outputs for description box
      
      modavepara<- reactive({
        telemetry.data%>%
          inner_join(assets, by=c("machineID"))%>%
          filter(model==param())%>%
          pivot_longer(c(3:6), "parameter") %>%
          filter(parameter == parat())%>%
          mutate(events=round(value,2))
      })
      
      output$macvalue<- renderText(paste0("Avg. in machine: ",round(mean(parad()$value),2))) 
      output$modvalue<- renderText(paste0("Avg. in Model: ", round(mean(modavepara()$value),2)))
      
      output$macage<- renderText(paste0("Machine age: ", round(filter(assets,machineID==input$mac_no)$age,2)))
      output$modage<-renderText(paste0("Avg. age in model: ", round(mean(filter(assets,model==param())$age),2)))
      

    }
  )
}