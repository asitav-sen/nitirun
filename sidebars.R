admin.sidebar<- sidebarMenu(
  menuItem(tabName = "homepage", "Home", icon = icon("home"), selected = T),
  menuItem(tabName = "explore", "Exploration", icon = icon("magic")),
  menuItem(tabName = "predict", "Predictions", icon = icon("hat-wizard")),
  menuItem(tabName = "machine", "Machine", icon = icon("space-shuttle")),
  menuItem(text = "About me", icon = icon("globe"), href = "https://asitavsen.com")
)

user1.sidebar<- sidebarMenu(
  menuItem(tabName = "homepage", "Home", icon = icon("home"), selected = T),
  menuItem(tabName = "predict", "Predictions", icon = icon("hat-wizard")),
  menuItem(tabName = "machine", "Machine", icon = icon("space-shuttle")),
  menuItem(tabName = "aboutme", "About me", icon = icon("globe"))
)

user2.sidebar <- sidebarMenu(
  menuItem(tabName = "homepage", "Home", icon = icon("home"), selected = T),
  menuItem(tabName = "explore", "Exploration", icon = icon("magic")),
  menuItem(tabName = "machine", "Machine", icon = icon("space-shuttle")),
  menuItem(tabName = "aboutme", "About me", icon = icon("globe"))
)