#-- This script is to test multiple output options that we can put in the shiny application
rm(list=ls())
load("data.rda")
library(plotly)
library(tidyverse)
library(leaflet)

#-- Plotting Lebanon's CO2 data using ggplot
plot_lebanon <- ggplot(df_lebanon, aes(x = Year, y = CO2_Emission)) + 
  geom_line() + 
  labs(y="Year", x = "Carbon Emission") +
  ggtitle("Lebanon's CO2 Emission data") +
  theme(plot.title = element_text(hjust = 0.5)) # to center title
print(plot_lebanon + ggtitle("Lebanon CO2 Emission Data"))

#-- testing plots of the final dataset using ggplot
#plot_EU <- ggplot(df_EU, aes(x = Year, y = CO2_Emission, color = Country)) + 
#  geom_line() + 
#  labs(y="Year", x = "Carbon Emission") +
#  ggtitle("Lebanon's CO2 Emission data") +
#  theme(plot.title = element_text(hjust = 0.5)) # to center title
#print(plot_EU + ggtitle("CO2 Emission across Europe"))


#-- testing dynamic data viz options (this is the best choice)

plot_ly(df_tab1, x = ~Year, y = ~CO2_Emission, color = ~Country, 
        colors = "Set1", type = 'scatter', mode = 'lines')

# plot_ly(df_EU, x = ~Year, y = ~CO2_Emission, color = ~Country, 
# type = 'scatter', mode = 'lines')

plot_ly(df_tab2, x = ~Year, y = ~CO2_Emission, color = ~Country,
        colors = "Set1", type = 'bar')

plot_ly(df_tab2, y = ~Country, x = ~CO2_Emission, color = ~Country,
        colors = "Set1", type = 'box', boxpoints = "all", jitter = 0.3,
        pointpos = -1.8)

plot_3 <- plot_ly(df_tab3, x = ~Year, y = ~CO2_Emission, colors = "darkblue",
        type = 'scatter', size = 2, mode = "markers")

plot_3 <- plot_3 %>% add_trace(x = ~Year, y = ~CO2_Emission, 
                           marker = list(color = 'rgba(17, 157, 255, 0.5)', 
                                         size = 20,
                                         line = list(color = 'rgb(231, 99, 250)',
                                                     width = 2)),
                           showlegend = F
  )
plot_3


#-- Cyril test
load("coordo.rda")

head(df_EU_coordo)
df_test <- filter(df_EU_coordo, Year == 2000)
head(df_test)

leaflet(data=df_test) %>% 
  addTiles() %>% 
  addCircleMarkers(lng = df_test$lon, lat = df_test$lat, 
                   radius = ~10*(CO2_Emission-mean(CO2_Emission))/sd(CO2_Emission),
                   fillOpacity = 0.5,
                   popup = ~paste(as.character(df_test$Country)))

df_test <- df_test[order(df_test$CO2_Emission),]
plot_ly(df_test, y = ~Country, x = ~CO2_Emission, type = 'bar', orientation='h')%>% 
  layout(yaxis = list(title = "",
                 categoryorder = "array",
                 categoryarray = ~Country))


