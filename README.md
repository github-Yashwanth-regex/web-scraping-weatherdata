🌦️ Web Scraping for Weather Data in R
📚 Project Overview
The primary aim of "Web Scraping for Weather Data in R" is to visualize Indian temperature data, analyze temperature anomalies, and examine temperature variations across different latitudinal bands within India. The project focuses on identifying the closest weather station to the user's location and retrieving data from the Weatherbit API.

Using several R libraries, this project preprocesses and cleans the retrieved data to create an interactive dashboard. The dashboard provides insights into temperature, pressure, and humidity variations through various interactive visualizations such as line plots, pie charts, bar graphs, and maps. It displays comprehensive current, forecasted, and historical weather data across various Indian cities, facilitating effective data presentation and analysis.

🌟 Key Features
Temperature Anomalies: Identifying unusual variations in temperature.
Latitudinal Bands: Examining temperature variations across different latitudes in India.
Interactive Dashboard: Built using Shiny, shinydashboard, and other packages to create an engaging user interface.
Weatherbit API: Retrieves live weather data including temperature, pressure, and humidity.
Data Preprocessing: Cleaned and processed data for seamless visualization.


📦 Libraries Used
This project makes use of the following R libraries:

shiny: For building interactive web applications.
shinydashboard: Provides a structured, clean layout for the Shiny app.
dplyr: Data manipulation and cleaning functions.
plotly: Interactive plotting library for visualizations.
leaflet: Used for creating interactive maps to visualize the weather data geographically.
httr: Used for making HTTP requests to the Weatherbit API.
DT: Provides interactive tables to display weather data.
🖥️ Shiny Dashboard
The Shiny dashboard is the heart of this project, providing an intuitive interface for users to visualize and analyze weather data. The dashboard features:

🌍 Dynamic Map: Displaying weather data points on an interactive map, making it easy to explore weather conditions across various cities in India.
🌡️ Temperature Plots: Interactive line charts showing temperature trends over time.
💧 Humidity and Pressure Visualizations: Using pie charts and bar graphs to depict humidity and pressure changes.
📊 Weather Data Table: An interactive table showing real-time weather data for different cities.
🔥 Features:
Users can select cities, view live weather updates, and analyze temperature anomalies.
📈 A forecasting model predicts future temperature variations based on current data.
The dashboard provides historical weather data with insights on latitudinal temperature patterns across India.
🚀 How to Run the Project
Clone this repository:

bash
Copy
Edit
git clone https://github.com/github-Yashwanth-regex/web-scraping-weatherdata.git
Install necessary packages:

r
Copy
Edit
install.packages(c("shiny", "shinydashboard", "dplyr", "plotly", "leaflet", "httr", "DT"))
Run the Shiny app:

r
Copy
Edit
shiny::runApp("path_to_app_directory")
The interactive dashboard will open in your default browser, allowing you to explore the weather data.

📄 License
This project is open-source and available under the MIT License.

🙏 Acknowledgments
Weatherbit API: For providing real-time weather data.
Shiny and its community: For creating such a powerful framework for building interactive web apps.
🌐 Publicly Deployed on shinyapps.io
Check out the live demo
Check out the live demo: [Web Scrape Dashboard](https://eysrikar.shinyapps.io/web-scrape-dashboard/)
