# During which months are forest fires most common? 
# On which days of the week are forest fires most common?
# One showing the number of forest fires occuring during each month
# Another showing the number of forest fires occurring on each day of the week

library(readr)
library(ggplot2)
library(dplyr)

forest_fires <- read_csv("/home/matiasconde/Documents/repos/Data-Science-Notebooks/ Analyzing Forest Fire Data/forestfires.csv")

forest_fires <- forest_fires %>%
  mutate(month = factor(month, levels = c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")), 
         day = factor(day, levels = c("sun","mon","tue","wed","thu","fri","sat")))

# DISTRIBUTION OF NUMBER OF FIRES PER DAY AND PER MONTH.

fires_per_day <- forest_fires %>%
  group_by(day) %>%
  summarize(`Number of Forest-Fire` = n()) # %>%
 # arrange(desc(`Number of Forest-Fire`))

fires_per_month <- forest_fires %>%
  group_by(month) %>%
  summarize(`Number of Forest-Fire` = n()) # %>%
#  arrange(desc(`Number of Forest-Fire`))

ggplot(data = fires_per_day) + 
  aes(x = day, y = `Number of Forest-Fire`) + 
  geom_bar(stat = "identity") + 
  theme(panel.background = element_rect(fill = "white"))	+ 
  labs(title = "Number of Forest Fire per Day")

ggplot(data = fires_per_month) + 
  aes(x = month, y = `Number of Forest-Fire`) + 
  geom_bar(stat = "identity") + 
  theme(panel.background = element_rect(fill = "white"))	+ 
  labs(title = "Number of Forest Fire per Month")

# DISTRIBUTION OF ANOTHER VARIABLES PER DAY AND PER MONTH. 


# FFMC: Fine Fuel Moisture Code index from the FWI system: 18.7 to 96.20
# DMC: Duff Moisture Code index from the FWI system: 1.1 to 291.3
# DC: Drought Code index from the FWI system: 7.9 to 860.6
# ISI: Initial Spread Index from the FWI system: 0.0 to 56.10
# temp: Temperature in Celsius degrees: 2.2 to 33.30
# RH: Relative humidity in percentage: 15.0 to 100
# wind: Wind speed in km/h: 0.40 to 9.40
# rain: Outside rain in mm/m2 : 0.0 to 6.4
# area: The burned area of the forest (in ha): 0.00 to 1090.84 


vars <- c("FFMC","DMC","DC","ISI","temp","RH","wind","rain")

variables_per_day <- function(x) {
  ggplot(data = forest_fires) + 
    aes(x = day, y = forest_fires[x]) + 
    geom_boxplot() + 
   # labs(title = "Variables per Day of the Week") + 
    theme(panel.background = element_rect(fill = "white"))
}


create_box_plots <- function(x,y) {
  ggplot(data = forest_fires) + 
    aes_string(x = x, y = y) + 
    geom_boxplot() + 
    labs(title = "Variables per Day of the Week") + 
    theme(panel.background = element_rect(fill = "white"))
}

# BOX PLOTS PER DAY

x_var = names(forest_fires)[4]
y_var = names(forest_fires)[5:12]

map2(x_var, y_var, create_box_plots)

# BOX PLOTS PER WEEK

x_var = names(forest_fires)[3]
y_var = names(forest_fires)[5:12]

map2(x_var, y_var, create_box_plots)

# the area variable contains data on the 
# number of hectares of forest that burned during the forest fire. 
# Perhaps we can use this variable as an indicator of the severity of the fire. 
#The idea is that worse fires will result in a larger burned area. 

# Let's create scatter plots to see what can be learned about relationships between 
# the area burned by a forest fire and the following variables: 

create_scatter <- function(x,y) {
  ggplot(data = forest_fires) + 
    aes_string(x = x, y = y) + 
    geom_point(alpha = 0.3) + 
    labs(title = "Burned area vs other variables") + 
    theme(panel.background = element_rect(fill = "white"))
}

x_var2 = names(forest_fires[5:12])
y_var2 = names(forest_fires[13])

map2(x_var2, y_var2, create_scatter)

# The result is that most points are clustered around the bottom of the plots. 

# A histogram of the area variable values clearly illustrates the distribution
# and why the scatter plots look the way they do: 

ggplot(data = forest_fires) + 
  aes(x = area) + 
  geom_histogram()

# We can see that a lot of values are arround of the zero. Then we can subset data into
# three categories: 0 value of area, 10-20 y 20 - 50

area_not_null <- forest_fires %>%
  filter(area > 0.1 & area <100)

create_scatter2 <- function(x,y) {
  ggplot(data = area_not_null) + 
    aes_string(x = x, y = y) + 
    geom_point(alpha = 0.3) + 
    labs(title = "Burned area vs other variables") + 
    theme(panel.background = element_rect(fill = "white"))
}

x_var2 = names(forest_fires[5:12])
y_var2 = names(forest_fires[13])

map2(x_var2, y_var2, create_scatter2)

