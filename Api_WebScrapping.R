library(shiny)
library(shinydashboard)
library(dplyr)
library(plotly)
library(leaflet)
library(httr)
library(DT)

# Define API Keys and Base URLs
API_KEY_CURRENT <- '71776b87e945488bb31f4080ab29b03c'
BASE_URL_CURRENT <- 'https://api.weatherbit.io/v2.0/current'
API_KEY_FORECASTED <- '71776b87e945488bb31f4080ab29b03c'
BASE_URL_FORECASTED <- 'https://api.weatherbit.io/v2.0/forecast/daily'
API_KEY_HISTORICAL <- 'a99eca1aa46a4bfdb72ce4b6995be809' 
BASE_URL_HISTORICAL <- 'https://api.weatherbit.io/v2.0/history/daily'

# Define list of cities with their coordinates
city_coordinates <- list(
  'Agra' = c(27.1767, 78.0081),
  'Ahmedabad' = c(23.0225, 72.5714),
  'Allahabad (Prayagraj)' = c(25.4358, 81.8463),
  'Amritsar' = c(31.6340, 74.8723),
  'Aurangabad' = c(19.8762, 75.3433),
  'Bengaluru (Bangalore)' = c(12.9716, 77.5946),
  'Bhopal' = c(23.2599, 77.4126),
  'Bhubaneswar' = c(20.2961, 85.8245),
  'Bilaspur' = c(22.0797, 82.1391),
  'Bokaro' = c(23.6693, 86.1511),
  'Chandigarh' = c(30.7333, 76.7794),
  'Chennai' = c(13.0827, 80.2707),
  'Coimbatore' = c(11.0168, 76.9558),
  'Cuttack' = c(20.4625, 85.8828),
  'Darjeeling' = c(27.0360, 88.2630),
  'Dehradun' = c(30.3165, 78.0322),
  'Delhi' = c(28.7041, 77.1025),
  'Dhanbad' = c(23.7957, 86.4304),
  'Durgapur' = c(23.5505, 87.2880),
  'Ernakulam' = c(9.9312, 76.2673),
  'Erode' = c(11.3410, 77.7172),
  'Etawah' = c(26.7767, 79.0237),
  'Faridabad' = c(28.4089, 77.3178),
  'Firozabad' = c(27.1509, 78.3975),
  'Gandhinagar' = c(23.2156, 72.6369),
  'Gangtok' = c(27.3389, 88.6065),
  'Ghaziabad' = c(28.6692, 77.4538),
  'Gorakhpur' = c(26.7606, 83.3732),
  'Guntur' = c(16.3067, 80.4365),
  'Hyderabad' = c(17.3850, 78.4867),
  'Haridwar' = c(29.9457, 78.1642),
  'Haldwani' = c(29.2197, 79.5128),
  'Hisar' = c(29.1539, 75.7224),
  'Hubli' = c(15.3647, 75.1240),
  'Imphal' = c(24.8170, 93.9368),
  'Indore' = c(22.7196, 75.8577),
  'Itanagar' = c(27.0844, 93.6053),
  'Jaipur' = c(26.9124, 75.7873),
  'Jabalpur' = c(23.1815, 79.9864),
  'Jamshedpur' = c(22.8046, 86.2029),
  'Jammu' = c(32.7266, 74.8570),
  'Jodhpur' = c(26.2639, 73.0551),
  'Kanpur' = c(26.4499, 80.3319),
  'Kochi' = c(9.9312, 76.2673),
  'Kolkata' = c(22.5726, 88.3639),
  'Kota' = c(25.2138, 75.8648),
  'Kozhikode (Calicut)' = c(11.2588, 75.7804),
  'Lucknow' = c(26.8467, 80.9462),
  'Ludhiana' = c(30.9010, 75.8573),
  'Madurai' = c(9.9252, 78.1198),
  'Mangalore' = c(12.9141, 74.8560),
  'Meerut' = c(28.6139, 77.2090),
  'Mumbai (Bombay)' = c(19.0760, 72.8777),
  'Mysore' = c(12.2958, 76.6394),
  'Nagpur' = c(21.1458, 79.0882),
  'Nashik' = c(20.5937, 78.9629),
  'Noida' = c(28.5355, 77.3910),
  'Ooty (Udhagamandalam)' = c(11.4064, 76.6932),
  'Ongole' = c(15.5036, 80.0445),
  'Patna' = c(25.5941, 85.1376),
  'Panaji' = c(15.4909, 73.8278),
  'Pune' = c(18.5204, 73.8567),
  'Puducherry (Pondicherry)' = c(11.9139, 79.8145),
  'Quilon (Kollam)' = c(8.8932, 76.6141),
  'Raipur' = c(21.2514, 81.6296),
  'Rajkot' = c(22.3039, 70.8022),
  'Ranchi' = c(23.3441, 85.3096),
  'Rourkela' = c(22.2604, 84.8536),
  'Salem' = c(11.6643, 78.1460),
  'Shimla' = c(31.1048, 77.1734),
  'Siliguri' = c(26.7271, 88.3953),
  'Srinagar' = c(34.0837, 74.7973),
  'Surat' = c(21.1702, 72.8311),
  'Thane' = c(19.2183, 72.9781),
  'Thiruvananthapuram (Trivandrum)' = c(8.5241, 76.9366),
  'Tiruchirappalli (Trichy)' = c(10.7905, 78.7047),
  'Tirupati' = c(13.6288, 79.4192),
  'Udaipur' = c(24.5854, 73.7125),
  'Ujjain' = c(23.1765, 75.7885),
  'Varanasi' = c(25.3176, 82.9739),
  'Vijayawada' = c(16.5062, 80.6480),
  'Visakhapatnam (Vizag)' = c(17.6868, 83.2185),
  'Vadodara (Baroda)' = c(22.3072, 73.1812),
  'Warangal' = c(17.9784, 79.6000),
  'Yamunanagar' = c(30.1290, 77.2674),
  'Zirakpur' = c(30.6420, 76.8174)
)

# Function to get current weather data
get_current_weather <- function(city) {
  url <- paste0(BASE_URL_CURRENT, "?city=", city, "&key=", API_KEY_CURRENT)
  response <- httr::GET(url)
  if (httr::status_code(response) == 200) {
    data <- httr::content(response, as = "parsed")
    if (length(data$data) > 0) {
      current_data <- data$data[[1]]
      return(data.frame(
        City = city,
        Date = paste(as.Date(current_data$ob_time), "(Current)"),
        Temperature = current_data$temp,
        Humidity = current_data$rh,
        Pressure = current_data$pres,
        WeatherDescription = current_data$weather$description,
        DataType = 'Current'
      ))
    }
  }
  return(NULL)
}

# Function to get forecasted weather data
get_forecasted_weather <- function(city) {
  url <- paste0(BASE_URL_FORECASTED, "?city=", city, "&key=", API_KEY_FORECASTED)
  response <- httr::GET(url)
  if (httr::status_code(response) == 200) {
    data <- httr::content(response, as = "parsed")
    if (length(data$data) > 0) {
      forecast_data <- data$data
      return(do.call(rbind, lapply(forecast_data, function(day) {
        data.frame(
          City = city,
          Date = paste(as.Date(day$datetime), "(Forecasted)"),
          Temperature = day$temp,
          Humidity = day$rh,
          Pressure = day$pres,
          WeatherDescription = day$weather$description,
          DataType = 'Forecasted'
        )
      })))
    }
  }
  return(NULL)
}

# Function to get historical weather data
get_historical_weather <- function(city, start_date, end_date) {
  url <- paste0(BASE_URL_HISTORICAL, "?city=", city, "&start_date=", start_date, "&end_date=", end_date, "&key=", API_KEY_HISTORICAL)
  response <- httr::GET(url)
  if (httr::status_code(response) == 200) {
    data <- httr::content(response, as = "parsed")
    if (length(data$data) > 0) {
      historical_data <- data$data
      return(do.call(rbind, lapply(historical_data, function(day) {
        data.frame(
          City = city,
          Date = paste(as.Date(day$datetime), "(Historical)"),
          Temperature = day$temp,
          Humidity = day$rh,
          Pressure = day$pres,
          DataType = 'Historical'
        )
      })))
    }
  }
  return(NULL)
}

# Define UI
# Define UI with enhanced styling
ui <- dashboardPage(
  dashboardHeader(
    title = span("Weather Dashboard", style = "font-weight: bold; color: #ffffff; text-shadow: 2px 2px #000000;")
  ),
  dashboardSidebar(
    tags$head(
      tags$style(HTML("
        .skin-blue .main-sidebar {
          background-color: #34495e; /* Sidebar background */
        }
        .skin-blue .main-sidebar .sidebar-menu .active a {
          background-color: #1abc9c; /* Active menu item */
          color: #ffffff; /* Text color */
        }
        .skin-blue .main-sidebar .sidebar-menu a:hover {
          background-color: #16a085; /* Hover color */
          color: #ffffff; /* Hover text color */
        }
      "))
    ),
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("chart-line")),
      menuItem("Piecharts", tabName = "piecharts", icon = icon("chart-pie")),
      menuItem("Map", tabName = "map", icon = icon("map-marked-alt")),
      menuItem("Weather Data", tabName = "weather_data", icon = icon("cloud-sun")),
      menuItem("Bar Graph", tabName = "bar_graph", icon = icon("chart-bar"))  # New menu item
    ),
    selectInput("city", "Select City", choices = names(city_coordinates)),
    actionButton("update", "Update Plots", class = "btn btn-primary")
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper {
          background-color: #ecf0f1; /* Background for body */
        }
        .box {
          border-radius: 10px; /* Smooth box edges */
          box-shadow: 2px 2px 5px #bdc3c7; /* Subtle shadow */
          background: linear-gradient(to bottom right, #ffffff, #e8e8e8); /* Gradient */
        }
        .box-header {
          background-color: #1abc9c; /* Header background */
          color: #ffffff; /* Header text */
          border-radius: 10px 10px 0 0; /* Rounded corners for header */
        }
        .box-title {
          font-weight: bold; /* Bold title */
        }
        .btn-primary {
          background-color: #16a085; /* Custom button color */
          border: none; /* Remove border */
        }
        .btn-primary:hover {
          background-color: #1abc9c; /* Hover effect for button */
        }
        .shiny-notification {
          background-color: #e74c3c; /* Notification background */
          color: white; /* Notification text */
          font-weight: bold; /* Bold text */
          border-radius: 10px; /* Smooth edges */
        }
      "))
    ),
    tabItems(
      tabItem(tabName = "plots",
              fluidRow(
                box(
                  plotlyOutput("temp_plot"),
                  title = "Temperature Variation",
                  width = 12
                ),
                box(
                  plotlyOutput("pressure_plot"),
                  title = "Pressure Variation",
                  width = 12
                ),
                box(
                  plotlyOutput("humidity_plot"),
                  title = "Humidity Variation",
                  width = 12
                )
              )
      ),
      tabItem(tabName = "piecharts",
              fluidRow(
                box(
                  plotlyOutput("temp_pie"),
                  title = "Temperature Components",
                  width = 12
                ),
                box(
                  plotlyOutput("pressure_pie"),
                  title = "Pressure Components",
                  width = 12
                ),
                box(
                  plotlyOutput("humidity_pie"),
                  title = "Humidity Components",
                  width = 12
                )
              )
      ),
      tabItem(tabName = "map",
              fluidRow(
                box(
                  leafletOutput("map"),
                  title = "Map",
                  width = 12
                )
              )
      ),
      tabItem(tabName = "weather_data",
              fluidRow(
                box(
                  dataTableOutput("weather_table"),
                  title = "Weather Data",
                  width = 12
                )
              )
      ),
      tabItem(tabName = "bar_graph",  # New tab for the bar graph
              fluidRow(
                box(
                  plotlyOutput("temp_bar"),
                  title = "Temperature Comparison",
                  width = 12
                ),
                box(
                  plotlyOutput("pressure_bar"),
                  title = "Pressure Comparison",
                  width = 12
                ),
                box(
                  plotlyOutput("humidity_bar"),
                  title = "Humidity Comparison",
                  width = 12
                )
              )
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$update, {
    city <- input$city
    if (is.null(city)) {
      showNotification("Please select a city.", type = "error")
      return()
    }
    
    # Fetch current weather data
    current_data <- get_current_weather(city)
    
    # Fetch forecasted weather data
    forecast_data <- get_forecasted_weather(city)
    
    # Fetch historical weather data for the past 7 days
    end_date <- Sys.Date()
    start_date <- end_date - 7
    historical_data <- get_historical_weather(city, start_date, end_date)
    
    # Combine all data
    combined_data <- bind_rows(historical_data, forecast_data, current_data)
    
    if (nrow(combined_data) == 0) {
      showNotification("No weather data available for the selected city.", type = "error")
      return()
    }
    
    # Sort data by date
    combined_data <- combined_data %>% arrange(Date)
    
    # Enhanced Temperature Plot
    output$temp_plot <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Temperature, type = 'scatter', mode = 'lines+markers',
              color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728'),
              hoverinfo = 'text', text = ~paste("Date:", Date, "<br>Temperature:", Temperature, "°C")) %>%
        layout(
          title = list(text = paste("<b>Temperature Trends in", city, "</b>"), x = 0.5),
          xaxis = list(title = "Date", showgrid = TRUE),
          yaxis = list(title = "Temperature (°C)", showgrid = TRUE),
          legend = list(title = list(text = "Data Type"))
        )
    })
    
    # Enhanced Pressure Plot
    output$pressure_plot <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Pressure, type = 'scatter', mode = 'lines+markers',
              color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728'),
              hoverinfo = 'text', text = ~paste("Date:", Date, "<br>Pressure:", Pressure, "hPa")) %>%
        layout(
          title = list(text = paste("<b>Pressure Trends in", city, "</b>"), x = 0.5),
          xaxis = list(title = "Date", showgrid = TRUE),
          yaxis = list(title = "Pressure (hPa)", showgrid = TRUE),
          legend = list(title = list(text = "Data Type"))
        )
    })
    
    # Enhanced Humidity Plot
    output$humidity_plot <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Humidity, type = 'scatter', mode = 'lines+markers',
              color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728'),
              hoverinfo = 'text', text = ~paste("Date:", Date, "<br>Humidity:", Humidity, "%")) %>%
        layout(
          title = list(text = paste("<b>Humidity Trends in", city, "</b>"), x = 0.5),
          xaxis = list(title = "Date", showgrid = TRUE),
          yaxis = list(title = "Humidity (%)", showgrid = TRUE),
          legend = list(title = list(text = "Data Type"))
        )
    })
    
    # Enhanced Pie Charts with Dynamic Labels
    output$temp_pie <- renderPlotly({
      plot_ly(combined_data, labels = ~paste(DataType, "(", Date, ")"), values = ~Temperature, type = 'pie',
              textinfo = 'label+percent', hoverinfo = 'label+value+percent', marker = list(line = list(color = '#FFFFFF', width = 1))) %>%
        layout(title = "Temperature Distribution")
    })
    
    output$pressure_pie <- renderPlotly({
      plot_ly(combined_data, labels = ~paste(DataType, "(", Date, ")"), values = ~Pressure, type = 'pie',
              textinfo = 'label+percent', hoverinfo = 'label+value+percent', marker = list(line = list(color = '#FFFFFF', width = 1))) %>%
        layout(title = "Pressure Distribution")
    })
    
    output$humidity_pie <- renderPlotly({
      plot_ly(combined_data, labels = ~paste(DataType, "(", Date, ")"), values = ~Humidity, type = 'pie',
              textinfo = 'label+percent', hoverinfo = 'label+value+percent', marker = list(line = list(color = '#FFFFFF', width = 1))) %>%
        layout(title = "Humidity Distribution")
    })
    # Map
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = city_coordinates[[city]][2], lat = city_coordinates[[city]][1], zoom = 10) %>%
        addMarkers(lng = city_coordinates[[city]][2], lat = city_coordinates[[city]][1], popup = city)
    })
    
    # Corrected Weather Data Table with DT
    output$weather_table <- renderDT({
      datatable(combined_data, options = list(
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
        pageLength = 10,
        autoWidth = TRUE
      ), class = 'cell-border stripe hover') %>%
        formatStyle(columns = names(combined_data), backgroundColor = 'lightblue', color = 'black', fontWeight = 'bold')
    })
    
    # Corrected Bar Graphs
    output$temp_bar <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Temperature, type = 'bar', color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728')) %>%
        layout(title = paste("Temperature Comparison in", city),
               xaxis = list(title = "Date"),
               yaxis = list(title = "Temperature (°C)"))
    })
    
    output$pressure_bar <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Pressure, type = 'bar', color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728')) %>%
        layout(title = paste("Pressure Comparison in", city),
               xaxis = list(title = "Date"),
               yaxis = list(title = "Pressure (hPa)"))
    })
    
    output$humidity_bar <- renderPlotly({
      plot_ly(combined_data, x = ~Date, y = ~Humidity, type = 'bar', color = ~DataType, colors = c('Historical' = '#1f77b4', 'Forecasted' = '#2ca02c', 'Current' = '#d62728')) %>%
        layout(title = paste("Humidity Comparison in", city),
               xaxis = list(title = "Date"),
               yaxis = list(title = "Humidity (%)"))
    })
  })
}
# Run the application
shinyApp(ui = ui, server = server)
