controlpanel<- dashboardControlbar(
  id="controlbar",
  width = 290,
  disable = FALSE,
  collapsed = TRUE,
  overlay = TRUE,
  skin = "dark",
  controlbarMenu(
    id="controlmenu",
    controlbarItem(
      value = "CompPrice",
      title = "Component Price",
      icon = icon("balance-scale-left"),
      sliderInput("comp1price", "Price: comp1", min=1, max=100, value=25),
      sliderInput("comp2price", "Price: comp2", min=1, max=100, value=30),
      sliderInput("comp3price", "Price: comp3", min=1, max=100, value=15),
      sliderInput("comp4price", "Price: comp4", min=1, max=100, value=20)
    ),
    controlbarItem(
      value = "MacPrice",
      title = "Machine Price",
      icon = icon("balance-scale-right"),
      sliderInput("mac1price", "Price: mac1", min=10000, max=100000, value=70000),
      sliderInput("mac2price", "Price: mac2", min=10000, max=100000, value=70000),
      sliderInput("mac3price", "Price: mac3", min=10000, max=100000, value=70000),
      sliderInput("mac4price", "Price: mac4", min=10000, max=100000, value=70000)
    ),
    controlbarItem(
      value = "production",
      title = "Production & Repair",
      icon = icon("industry"),
      sliderInput("prodrate", "Per hour production ($)", min=10, max=1000, value=400),
      sliderInput("reptime", "Time required to repair (min)", min=10, max=50, value=45)
    )
  )
)