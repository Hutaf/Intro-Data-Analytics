## Code from chapter
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))
## Section 16.2.4 Exercises
# 1. What happens if you parse a string that contains invalid dates?
   ymd(c("2010-10-10", "bananas"))
## Answer: it will parse the date and the string to NA then showing a warning msg "1 failed to parse."

# 2. What does the tzone argument to today() do? Why is it important?
?today()
## Answer: tzone is a character vector specifying which time zone you would like the current time in.
##         tzone defaults to your computer's system timezone.
## it is important since the value returned by today depends on the tzone, knowing that different tzones have different dates

# 3. Use the appropriate lubridate function to parse each of the following dates:
  
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
ymd(d2)
d3 <- "06-Jun-2017"
dmy(d3)
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14" # Dec 30, 2014
mdy(d5)
#####################################################
# Section 16.3.4 Exercises

# 1. How does the distribution of flight times within a day change over the course of the year?
## Answer:

flights_dt %>%
  mutate(dep_hour = hour(dep_time) * 100 + minute(dep_time),
         month = factor(month(dep_time))) %>%
  ggplot(aes(x = dep_hour, y = ..density.., group = month, color = month)) +
  geom_freqpoly(binwidth = 100)
# 2. Compare dep_time, sched_dep_time and dep_delay. Are they consistent? Explain your findings.
## Answer: if they are consistent the dep_time will be equal to the sum of sched_dep_time and dep_delay
flights_dt %>%
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(delay_dep_time = (dep_time - sched_dep_time) / 60) %>%
  filter(dep_delay != delay_dep_time) %>%
  nrow()
## So, they are not consistent due to some mistakes while entering the dates 
## resulting with 1205 inconsistent rows

# 3. Compare air_time with the duration between the departure and arrival. Explain your findings. (Hint: consider the location of the airport.)
## Answer: 
flights_dt %>%
  mutate(
    actual_air_time = as.numeric(arr_time - dep_time),
    difference = actual_air_time - air_time
  ) %>%
  select(origin, dest, actual_air_time, air_time, difference)
## I really can’t explain the difference. But, air_time is the time of flight from departure to arrival, and maybe the values are not exact time of departure and arrival of the plane

# 4. How does the average delay time change over the course of a day? Should you use dep_time or sched_dep_time? Why?
## Answer:

flights_dt %>%
  mutate(sched_dep_hour = hour(sched_dep_time)) %>%
  group_by(sched_dep_hour) %>%
  summarise(dep_delay = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay, x = sched_dep_hour)) +
  geom_line()+ 
  scale_x_continuous(name="Schedualed departure hour") +
  scale_y_continuous(name="departure delay")
?gather
# 5. On what day of the week should you leave if you want to minimise the chance of a delay?
## Answer: 

flights_dt %>%
  mutate(dayofweek = wday(dep_time, label = TRUE)) %>% 
  group_by(dayofweek) %>% 
  summarize(avg_dep_delay = mean(dep_delay, na.rm = TRUE),
            avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  gather(key = 'delay', value = 'minutes', 2:3) %>%
  ggplot(mapping = aes(x = dayofweek, y = minutes, fill = delay)) + 
  geom_col(position= "dodge")

## According to the plot, Saturdays are the best days to fly 

# 6. What makes the distribution of diamonds$carat and flights$sched_dep_time similar?
## Answer:
diamonds %>%
  ggplot() +
  geom_freqpoly(mapping = aes(x = carat))

flights_dt %>%
  mutate(minutes = minute(sched_dep_time)) %>%
  ggplot() +
  geom_freqpoly(mapping = aes(x = minutes), binwidth = 1)

## I am not sure about this but maybe because y decreases while x increases 
## Both have the same plot shape 

# 7. Confirm my hypothesis that the early departures of flights in minutes 20-30 and 50-60 are caused by scheduled flights that leave early.
# Hint: create a binary variable that tells you whether or not a flight was delayed.

## Answer:
flights_dt %>%
  mutate(minutes = minute(sched_dep_time),
         delay = dep_delay > 0) %>%
  group_by(minutes) %>%
  summarize(prop_early = 1 - mean(delay, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(mapping = aes(x = minutes, y = prop_early))
## This means that the proportion of early departures is highest between minutes 0-9 and 10–20 .

#####################################################
# Section 16.4.5 Exercises
# 1. Why is there months() but no dmonths()?
## Answer: Maybe because months have different number of days, I mean the month does not have a fixed duration like hour, seconds, and days

# 2. Explain days(overnight * 1) to someone who has just started learning R. How does it work?
## Answer: Using flight table as an example, you can see that some flights are arrived before they actually departed
## This is because they are overnight flight to solve this we will use a boolean variable called overnight to identify 
## all overnight flights then we will use them to add day(overnight * 1) to the arrival time to solve the problem of overnight flights
## Refer to section 16.4.2

# 3. Create a vector of dates giving the first day of every month in 2015. Create a vector of dates giving the first day of every month in the current year.
## Answer:
## a vector of dates giving the first day of every month in 2015
(year2015 <- years(2015) + months(c(1:12)) + days(1))
## a vector of dates giving the first day of every month in the current year.
(currentyear <- year(today()) + months(c(1:12)) + days(1))


# 4. Write a function that given your birthday (as a date), returns how old you are in years.
## Answer:
BD <- function(birthday){
 age_days <- (today() - birthday)
 age_years <- floor(age_days/dyears(1))
cat(" Your age in years is ", age_years, sep = " ")
cat(" ", sep = "%\n")
cat(" Your age in days is ", age_days,sep = " ")}

BD(dmy("31-07-1997"))
# 5. Why can’t (today() %--% (today() + years(1))) / months(1) work?
(today() %--% (today() + years(1))) / months(1)

## Answer: it works with me 
## But maybe it is the same problem discussed in interval section 16.4.3.