#-- This script is for data cleaning and creating multiple datasets from the original one
rm(list=ls())
library(tidyverse)

df <- read.csv("CO2_data.csv", header = T) %>% as_tibble()
head(df)

#-- we notice that there is an unnecessary variable "Code ISO" so we will drop it
#-- we will rename the variables and transform the year to a date object

df["Code"] <- NULL
df <- rename(df, CO2_Emission = Annual.CO..emissions..tonnes.., Country = Entity)
head(df)

#-- Performing summary and checking for missing values
summary(df[,c(2,3)])
if (!sum(is.na(df))) cat("Data does not contain missing values")

#-- Exploring the country variable. We notice that there are continents and world as well as countries
unique(df$Country)

#-- There is a peculiar row called Statistical differences that does not seem to contain any values
#-- we will drop the rows of these values
a <- which(df[,1]=="Statistical differences")
df[a,]
df <- df[-a,]

#-- It seems that for some countries, we only have data starting 1949. Therefore, we will explore only EU countries
#-- Idea : we can see the effect of CO2 emissions through the first and second world wars (1910 through 1950)

test <- filter(df, Year >= 1900)
test[which(test["CO2_Emission"] ==0),]

EU <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
        "Czech Republic","Denmark","Estonia","Finland","France",
        "Germany","Greece","Hungary","Ireland","Italy","Latvia",
        "Lithuania","Luxembourg","Malta","Netherlands","Poland",
        "Portugal","Romania","Slovakia","Slovenia","Spain",
        "Sweden","United Kingdom")

#-- Match all European countries with the countries in the data set and return indexes
EU_index <- which(!is.na(match(df$Country, EU)))
df_EU <- df[EU_index,]

#-- Test that we really have all the European countries in the dataset using all equal and unique
#-- Note that this will make it easier to get the coordinates of the countries
b <- as.character(unique(df_EU$Country))
all.equal(EU,b)
head(df_EU)

#-- Lets see which years these countries do not have any registered values
#-- It seems that we have full data from 1900 to 2017. we will use them
filter(df_EU, CO2_Emission == 0)
df_EU <- filter(df_EU, Year >= 1900)
summary(df_EU[,c(2,3)])

#-- It would be interesting to extract a dataset that handles only countries that faught in the
#-- world war II. These countries are

WW2 <- c("Germany", "Italy", "Japan", "France", "Poland",
         "United Kingdom", "United States","China")
WW2_index <- which(!is.na(match(df$Country, WW2)))
df_WW2 <- df[WW2_index,]
c <- as.character(unique(df_WW2$Country))
df_WW2 <- filter(df_WW2, Year >= 1900)


#-- we will also create f w datasets for testing, one only containing few countries and one for lebanon
df_lebanon <- filter(df, Country == "Lebanon", Year >= 1900)

df_tab1 <- filter(df_EU, Country %in% c("France", "United Kingdom", "Italy", "Poland", "Germany"))
df_tab1$Country <- gsub("United Kingdom", "UK", df_tab1$Country)
df_tab1$Country <- factor(df_tab1$Country)

df_tab2 <- filter(df_EU, Year >=1945, Country %in% c("France", "United Kingdom", "Italy", "Germany", "Poland"))  #from that year on, CO2 drops
df_tab2$Country <- factor(df_tab2$Country)

df_tab3 <- filter(df_EU, Country %in% c("France"), Year >=1978)
df_tab3$Country <- factor(df_tab3$Country)

#-- we will save all three datasets to an .rda file



save(df_tab1, df_tab2, df_tab3, df_lebanon, df_EU, file = "data.rda")