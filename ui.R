library(shinydashboard)

dashboardPage( 
  dashboardHeader(title = "Lanqing's Dahboard",
                  titleWidth = 230
                  ), 
  dashboardSidebar(
    # sidebarUserPanel(
    #   "Lanqing Yang", subtitle = "NYC Data Science Fellow", 
    #   image = "daisy.png"),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("User Review", tabName = "review", icon = icon("comments")),
      menuItem("Neighbourhood", tabName = "neighbourhood", icon = icon("city")),
      menuItem("Subway Distance", tabName = "subway", icon = icon("subway")),
      menuItem("Seasonality", tabName = "season", icon = icon("calendar")),
      menuItem("Data", tabName = "data", icon = icon("database"))
      )
    ), 
dashboardBody(
    tabItems(
      tabItem(tabName = "map",
                sidebarPanel(
                  checkboxGroupInput("room_select", "Room Type",
                                     choices = room_type, selected = room_type),
                  sliderInput("price", "Price",
                              min = 0,  max = 1000,  step = 50,
                              pre = "$", sep = ",", value = c(10, 500)),
                  sliderInput("score", "Rating Score",
                              min = 20, max = 100, step = 10,
                              value = c(80, 100)),
                  sliderInput("num_review", "Number of Reviews",
                              min = 0, max = 400, step = 50,
                              value = c(150, 400))
                ),
                mainPanel(
                  box(title = "NYC Airbnb Listings", status="info", solidHeader = T,
                      width = 205, leafletOutput("map"))
                  )
              ),
      tabItem(tabName = "review",
                sidebarPanel(
                  sliderInput("max", "Maximum Number of Words:",
                              min = 5,  max = 200,  value = 100)
                  ),
                mainPanel(
                  box(title = "User Reviews", status="info", solidHeader = T,
                      width = 75, plotOutput("plot"))
                  )
              ),
      tabItem(tabName = "neighbourhood",
                sidebarPanel(
                  selectizeInput("boro", "Neighbourhood",
                                 choices = unique(listings.df$boro))),
                mainPanel(
                  box(title = "Neighbourhood and Price", status="info", solidHeader = T,
                      width = 75, plotOutput("boro"))
                  )
              ),
      tabItem(tabName = "subway",
                sidebarPanel(
                  selectizeInput("boro_select", "Neighbourhood", choices = unique(subway.df$boro))
                ),
                mainPanel(
                  box(title = "Distance to Subway and Price", status="info", solidHeader = T,
                      width = 75, plotOutput("subway"))
                )
              ),
      tabItem(tabName = "season",
                sidebarPanel(
                  selectizeInput("year", "year", choices = c(2019, 2018, 2017))
                ),
                mainPanel(
                  tabBox(
                    title = "Seasonality", width = 75,
                    tabPanel("Price", plotOutput("price")),
                    tabPanel("Reviews", plotOutput("season"))
                    )
                  )
              ),
      tabItem(tabName = "data",
              #datatable
              fluidPage(box(DT::dataTableOutput("table"), width = 12)))
      )))




