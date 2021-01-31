homepage<-
  fluidPage(
    theme = shinytheme("cyborg"),
    fluidRow(
      box(
        status= "primary",
        width= 12,
        height = "300px",
        h1("Predictive Maintenance Dashboard"),
        br(),
        br(),
        h5("Replacement schedules defined by OEMs is not customized to your circustances. 
                You may be spending a lot more than needed; either in replacements or in failures. Do you want to keep losing money in maintenance?"),
        fluidRow(
          column(
            width = 3,
            br(),
            actionButton("goButton", "No, I don't want to lose money anymore", class = "btn-success", width = "100%")
          ),
          column(
            width= 9
          )
        )
      )
    ),
    fluidRow(
      column(
        width = 6,
        box(
          title = "What does the dashboad contain?",
          status = "info",
          solidHeader = T,
          width = 12,
          p("The dashboard contains sections of exploration and prediction. In exploration, one can start from an overall
                summary of status quo and then drill down to the machine level to undertand \"What happened\". In prediction, for each component
                an optimized replacement hour is calculated. The costs (recommended replacement hours vs. current practice) are compared and 
                estimated savings are calculated. A list of items that may need replacement are also shown.")
        ),
        box(
          status = "info",
          title = "What is the data about?",
          solidHeader = T,
          width = 12,
          p("The data is from real life. It contains details from 100 machines of one of the four models (model1, model2,..,model4). Each machine
                contains four components (comp1, comp2,..,comp4. Sceduled and unscheduled (failures) replacement history is also provided.
                Hourly rotation,vibration, pressure and voltage is recorded in telemetry data. We used one year's data.")
        ),
        box(
          status = "info",
          title = "How use the dashboard?",
          solidHeader = T,
          width = 12,
          p("Simply go to the relevant tabs by clicking on the menu in the sidebar. You can control the price of parts and machine
                from the control panel. The control panel is located on the right upper conter and can be accessed by clicking on the gear button.")
        ),
        box(
          status = "info",
          title = "Why not use other dashboarding tools?",
          solidHeader = T,
          width = 12,
          p("Sure you can. We can build the predictive model and provide data. The predicted data and the explorative data
                  (For e.g. maintenance data) can be shown using any dashboarding tool. However, we would recommed shiny because
                  it is open source and you don't need to pay a monthly fee for the dashboarding tool itself. Which you need to, when you are 
                  using other proprietory tools. Free and very cheap hosting options are also available. But, most importantly, if you think of
                  the pinnacle of customized dashboard, you would think Shiny. The customization options and vizualization options are simply
                  unmatched.")
        ),
        box(
          status = "info",
          title = "Who am I?",
          solidHeader = T,
          width = 12,
          p("I'm a data scientist and commercial strategist. You may find more about me at my website www.asitavsen.com")
        )
      ),
      
      column(
        width = 6,
        box(
          status = "warning",
          title = "What is it all about?",
          solidHeader = T,
          width = 12,
          p("Manufacturers do not know in which circumstance is your equipment running. When they recommend a replacement
                schedule it is very generic. For e.g. if you are running your machine in desert, you cannot expect it to behave in 
                the same manner, had it beed running on sea. 
                We can help you calculate the optimum replacement hours based on evidence from data and a little math. It will either increase
                the replacement hours, or increase the machine reliability. Either way, it saves you money.")
        ),
        box(
          status = "warning",
          title = "How does it work?",
          solidHeader = T,
          width = 12,
          p("We take your telemetry, maintenance and failure data to predict probability of failure at a given time. Then, taking
                into consideration the replacement cost and cost of machine failure, we do some math to optimize.")
        ),
        box(
          status = "warning",
          title = "How accurate are the prediction?",
          solidHeader = T,
          width = 12,
          p("We can only answer this question accurately after analyzing your data. However, if this helps to build
                your confidence, some of the algorithm we use are used even in medical science!")
        ),
        box(
          status = "warning",
          title = "What are the risks?",
          solidHeader = T,
          width = 12,
          p("Well, the algorithm predicts based on past events that are recorded. If a failure occures due to reasons that
                were never recorded before or some unforeseen reason, that can obviously not be predicted. Excluding these situations,
                we can provide a quantified risk, after analysis of data.")
        ),
        box(
          status = "warning",
          title = "How much time does it take?",
          solidHeader = T,
          width = 12,
          p("It depends on the complexity of the problem and the level of customization and functions. In certain situations,
                  a minimum viable product can be built even within a couple of weeks to a month.")
        )
      )
      
    )
  )