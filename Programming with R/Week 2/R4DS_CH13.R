library(tidyverse)
library(nycflights13)

View(airports)
# Section 13.2.1 Exercises
# 1. Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination. What variables would you need? What tables would you need to combine?
## Answer: In order to draw a route for each plane, we need the longitude and latitude for the origin and destination
## This requires the origin and dest from`flights` table and 
## lon and lat variables from `airports` table. I will use inner join to combine the tables

## Code

des <- select(airports, dest = faa, dest_lat = lat, dest_lon = lon)
origin <- select(airports, origin = faa, origin_lat = lat, origin_lon = lon)
route <- flights %>%
  inner_join(origin,
             by = "origin"
  ) %>%
  inner_join(des,
             by = "dest"
  )

route
# 2. I forgot to draw the relationship between weather and airports. What is the relationship and how should it appear in the diagram?
## Answer: The relationship between the tables will be using origin column from weather since faa is a foreign key of the origin columns.
## Moreover, the relation represented via a straight line between airports$faa and weather$origin

# 3. weather only contains information for the origin (NYC) airports. If it contained weather records for all airports in the USA, what additional relation would it define with flights?
## Answer: If weather contained  records for all airports in the USA, the additional relation would it define with flights columns (`year`, `month`, `day`, `hour`, `dest`).

# 4. We know that some days of the year are “special”, and fewer people than usual fly on them. How might you represent that data as a data frame? What would be the primary keys of that table? How would it connect to the existing tables?
## Answer: I would like to add a table ("specialdays") contained all records for special dates and the columns (`year`, `month`, `day`) will be the primary key of the table, so it will be connected to all tables via the primary key
#########################################################
# Section 13.3.1 Exercises

# 1. Add a surrogate key to flights.

## Answer: adding row numbers column as flight_id 
flights %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

## Answer: adding row numbers column as flight_id after arranging the flight table
flights %>%
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

# 2. Identify the keys in the following datasets
#(You might need to install some packages and read some documentation.)
#Lahman::Batting
Lahman::Batting %>%
  count(playerID, yearID, stint) %>%
  filter(n > 1) 
#babynames::babynames
babynames::babynames %>%
  count(year, sex, name) %>%
  filter(n > 1) %>%
  nrow()
#nasaweather::atmos
nasaweather::atmos %>%
  count(lat, long, year, month) %>%
  filter(n > 1) %>%
  nrow()
#fueleconomy::vehicles
fueleconomy::vehicles %>%
  count(id) %>%
  filter(n > 1) %>%
  nrow()
#ggplot2::diamonds
# Number of distinct rows = 53794
ggplot2::diamonds %>%
 distinct() %>%
  nrow()
## Number of rows = 53940
ggplot2::diamonds %>%
  nrow()
## Answer: The num of rows is larger than num of unique observation. This means there's no primary key that identifys each observation 
## Solution: I created a surrgate key for the diamonds table called diamond_id
ggplot2::diamonds %>%
  mutate(diamond_id = row_number()) %>%
  glimpse()

# 3. Draw a diagram illustrating the connections between the Batting, People, and Salaries tables in the Lahman package. Draw another diagram that shows the relationship between People, Managers, AwardsManagers.
# How would you characterise the relationship between the Batting, Pitching, and Fielding tables?
## Answer: The only package that can draw database schema diagrams is (datamodelr) and its not updated yet, so
## First: identify and create a table consists of primary and foreign keys in each following table 
## for the first relation:
## Master: Primary key: playerID
## Batting: Primary key: playerID, yearID, stint ; Foreign keys: playerID = playerID from master table
## Salaries: Primary key: yearID, teamID, playerID ; Foreign keys: playerID = playerID from master table
## Second: use "datamodelr" to identify the relation based on then keys then gragh it  
#########################################################
# Section 13.4.6 Exercises
# 1. Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:
  airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
#(Don’t worry if you don’t understand what semi_join() does — you’ll learn about it next.)
#You might want to use the size or colour of the points to display the average delay for each airport.
## Answer:
(avr_arr_dest <- 
  flights %>%
  group_by(dest) %>%
  summarise(avr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa")))

# Graph
avr_arr_dest %>%
  ggplot(mapping = aes(lon, lat, colour = avr_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2. Add the location of the origin and destination (i.e. the lat and lon) to flights.
## Answer:

origin <- flights %>%
  select(year:day, hour, origin, dest) %>%
  left_join(
    (airports %>% select(faa, lat, lon)),
    by = c("origin" = "faa")
  )
origin %>%
  left_join(
    (airports %>% select(faa, lat, lon)),
    by = c("dest" = "faa")
  )
# 3. Is there a relationship between the age of a plane and its delays?
## Answer:
plane <- inner_join(flights,
                    select(planes, tailnum, plane_year = year),
                    by = "tailnum") %>%
  mutate(age = year - plane_year) %>%
  filter(!is.na(age)) %>%
  group_by(age) %>% 
  summarise(
    avr_dep_delay = mean(dep_delay, na.rm = TRUE),
    avr_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  glimpse()

## Average Arrival delay
ggplot(plane, aes(x = age, y = avr_arr_delay)) +
  geom_point()

## Average Departure delay
ggplot(plane, aes(x = age, y = avr_dep_delay)) +
  geom_point()

## The highest number of delays happened when the plane age is 10 then it decrease
## as the plane getting older. so, I think there is a relationship between them 

# 4. What weather conditions make it more likely to see a delay?
## Answer:
flight_weather <-
  flights %>%
  inner_join(weather, by = c(
    "origin" = "origin",
    "year" = "year",
    "month" = "month",
    "day" = "day",
    "hour" = "hour"
  )) %>%
  glimpse()
## The question does not specify which delay so I chose arrival delay to compare with weather
## visibility
flight_weather %>%
  group_by(visib) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = visib, y = delay)) +
  geom_line()
## When visibility increases the delay is decreses

## humid
flight_weather %>%
  group_by(humid) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = humid, y = delay)) +
  geom_line()
## I Can not see if there is actual relationship between humid and delays

## temp
flight_weather %>%
  group_by(temp) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = temp, y = delay)) +
  geom_line()
## I Can not see if there is actual relationship between temp and delays. but I think
## that when the temperature increases thr delays are also increase 

# 5. What happened on June 13 2013? Display the spatial pattern of delays, and then use Google to cross-reference with the weather.
## Answer: 
delay2013 <- flights %>%
  filter(year == 2013 & month == 6 & day == 13 ) %>%
  group_by(dest) %>% 
  summarise(
    avr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  glimpse()

# Graph
delay2013 %>%
  ggplot(mapping = aes(lon, lat, colour = avr_delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
#########################################################
# Section 13.5.1 Exercises
# 1. What does it mean for a flight to have a missing tailnum? What do the tail numbers that don’t have a matching record in planes have in common? (Hint: one variable explains ~90% of the problems.)
## Answer: 
flights %>%
  filter(is.na(tailnum))
## Answer: flights that have a missing tailnum all have missing values of arr_time,dep_time, dep_delay, and arr_delay
## meaning that all these flights were canceled
# 2. Filter flights to only show flights with planes that have flown at least 100 flights.
## Answer:
flights_100 <- flights %>%
  filter(!is.na(tailnum)) %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n >= 100)
## semi join
flights %>%
  semi_join(flights_100, by = "tailnum")
# 3. Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models.
## Answer:
## The most common models
fueleconomy::vehicles %>%
  semi_join(fueleconomy::common, by = c("model"))
## The most common models and the brands since many brands usually use the same model name
## so, combining make and model columns create a unique list of common models
fueleconomy::vehicles %>%
  semi_join(fueleconomy::common, by = c("model", "make"))

# 4. Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?
## Answer:
## Still working on this
# 5. What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?
## Answer:
anti_join(flights, airports, by = c("dest" = "faa"))
# Return the flights from the destinations that that are not present in the airports dataset.
anti_join(airports, flights, by = c("faa" = "dest"))
# Return the airports that are not present as destinations in the flights dataset.

# 6. You might expect that there’s an implicit relationship between plane and airline, because each plane is flown by a single airline. Confirm or reject this hypothesis using the tools you’ve learned above.
## Answer:
airlines
planes %>%
  glimpse()
flights %>%
  glimpse()
## a list of  planes and carriers
list_plane_carrier <-
  flights %>%
  filter(!is.na(tailnum)) %>%
  distinct(tailnum, carrier) %>% 
  glimpse()
## a list of planes, carrier, and full name of carriers
table_carriers <- list_plane_carrier %>%
  left_join(airlines, by = "carrier") %>%
  glimpse()
## planes that have flown with more than a single airline
table_carriers  %>%
  count(tailnum) %>%
  filter(n > 1)
## Rejected. Planes can be fly for more than a single airline during its lifetime which 
## already confirmed by the above queries there is around 17 plane worked for more than a single airline
## during 2013
