library(tidyverse)
library(ggplot2)
## Section 12.2.1 Exercises
# 1. Using prose, describe how the variables and observations are organised in each of the sample tables.
table1
table2
table3
table4a
table4b
table5
## Answer:
## In table1, each observation has its own row and each variable has its own column.
## In table2, each row represents country, year, and the type of either case or population. The count represents a unique value for the variable type.
## In table3, each row represents country, year, and the case and population are mutated into rate and separated by /
## In table4a and table4b, each row represents country, cases, and population. The variable year presented as two values "1999" and "2000" 
## In table5, each row represents country, century, and year. The case and population are mutated into rate variable and separated by /

# 2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
country <- filter(table2, type == 'cases')$country
# * Extract the number of TB cases per country per year.
case <- filter(table2, type == 'cases')$count
# * Extract the matching population per country per year.
population <- filter(table2, type == 'population')$count
# * Divide cases by population, and multiply by 10000.
rate = (case/population) * 10000
# * Store back in the appropriate place.
(Table2_rate <- data.frame("Country" = country, "Year"= c(1999,2000), "Rate"= rate))

## Table4a and Table4b
countries <- table4a$country
# * Extract the number of TB cases per country per year.
case_1999 <- table4a$`1999`
case_2000 <- table4a$`2000`
# * Extract the matching population per country per year.
population_1999 <- table4b$`1999`
population_2000 <- table4b$`2000`
# * Divide cases by population, and multiply by 10000.
rate_1999 <- (case_1999/population_1999) * 10000
rate_2000 <- (case_2000/population_2000) * 10000
# * Store back in the appropriate place.
table4_rate99 <- tibble(country = countries,
                          year = 1999,
                          rate = rate_1999)

table4_rate00 <- tibble(country = countries,
                          year = 2000,
                          rate = rate_2000)

(Table4_rate <- rbind(table4_rate99, table4_rate00 )%>% arrange(country))
# Which representation is easiest to work with? Which is hardest? Why?
## Answer: Table2 much easier since it has less number of steps 

# 3. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?
(table2_plot = filter(table2, type == 'cases'))
ggplot(data = table2_plot,
       mapping = aes( year, count)) +
  geom_line(mapping = aes(group = country),color = 'grey50') +
  geom_point(mapping = aes(color = country)) +
  labs(y = 'cases') 

#####################################################
# Section 12.3.3 Exercises

# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical? Carefully consider the following example:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return", names_ptype = list(year = double()))

## Answer: the pivot_longer() and pivot_wider() are not perfectly symmetrical due to the lost of variable type (year)
## We used names names_ptype = list(year = double()) to return the tyoe of variav=ble from char to dbl but it throw error when I run it 
## (Error: Can't convert <character> to <double>.)


# 2. Why does this code fail?
table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")
#> Error: Can't subset columns that don't exist.
#> ✖ The locations 1999 and 2000 don't exist.
#> ℹ There are only 3 columns.
## Answer: the years are not numbers that's why it throw this error
## to solve this just add double quotation to treat years as string
table4a %>% 
  pivot_longer(c("1999", "2000"), names_to = "year", values_to = "cases")

# 3. What would happen if you widen this table? Why? How could you add a new column to uniquely identify each value?
 
 ( people <- tribble(
    ~name,             ~names,  ~values,
    #-----------------|--------|------
    "Phillip Woods",   "age",       45,
    "Phillip Woods",   "height",   186,
    "Phillip Woods",   "age",       50,
    "Jessica Cordero", "age",       37,
    "Jessica Cordero", "height",   156
  ))
pivot_wider(people, names_from = names, values_from = values)

## Answer: pivot_wider() fails because the name and key columns do not uniquely identify the rows.

# 4. Tidy the simple tibble below. Do you need to make it wider or longer? What are the variables?

(preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
))

preg %>%
  pivot_longer(c(female, male), names_to = "gender", values_to = "count")

##################################################################################
# Section 12.4.3 Exercises
# 1. What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = 'drop')

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")
## Answer: ?separate
## extra: If sep is a character vector, this controls what happens when there are too many pieces.
## fill: If sep is a character vector, this controls what happens when there are not enough pieces. 

# 2. Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?
## Answer: remove: If set tp TRUE, remove input column from output data frame. otherwise, the original separate column, or the united columns, are retained in the output.

# 3. Compare and contrast separate() and extract(). Why are there three variations of separation (by position, by separator, and with groups), but only one unite?
## Answer: I don't understand extract() completely but it uses regular expression to capture and extract groups and turn them into columns.

#################################################################
# Section 12.5.1 Exercises
# 1. Compare and contrast the fill arguments to pivot_wider() and complete().
## Answer:  
## complete():  it accepts a list where each cell is the missing value for each column.
## pivot_wider(): it called values_fill, value that specifies what each value should be filled in with when missing
# 2. What does the direction argument to fill() do?
info <- tribble(
  ~ name,           ~ age, ~gender,
  "Hutaf Raja",       23,           "F",
  NA,                 55,           "M",
  NA,                 30,           "F",
  "Saher R.",         18,           "M"
)
(down <- fill(info, name, .direction = "down"))
(up <- fill(info, name, .direction = "up"))

## Answer: We have two missing values in name column.
## Using up, We can carry over the value "Saher R." to replace the missing values
## Using down, We can carry over the value "Hutaf Raja"` to replace the missing values. 

#############################################################
# Section 12.6.1 Exercises

# 1. In this case study I set values_drop_na = TRUE just to make it easier to check that we had the correct values. 
# Is this reasonable? Think about how missing values are represented in this dataset. Are there implicit missing values? What’s the difference between an NA and zero?
## Answer: In our case, it's reasonable. But if we're doing an analysis, No it is not because even if it's missing values, still that's information

# 2. What happens if you neglect the mutate() step? (mutate(names_from = stringr::str_replace(key, "newrel", "new_rel")))
## Answer: The code will not be separated properly.

# 3. I claimed that iso2 and iso3 were redundant with country. Confirm this claim.
who %>%
  count(country, iso2, iso3) %>%
  count(country) %>%
  filter(n > 1)

## Answer: Thus we can confirm that iso2 and iso3 were redundant with country.

# 4. For each country, year, and sex compute the total number of cases of TB. Make an informative visualisation of the data.
# Processing
(who1 <- who %>% 
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ))

(who2 <- who1 %>% 
  mutate(names_from = stringr::str_replace(key, "newrel", "new_rel")))

(who3 <- who2 %>% 
    separate(key, c("new", "type", "sexage"), sep = "_"))

(who4 <- who3 %>% 
  separate(sexage, c("sex", "age"), sep = 1))

# Visualization
who4 %>%
  group_by(country, year, sex) %>%
  summarise(cases = sum(cases)) %>%
  ggplot(aes(x = year, y = cases, group = country, colour = sex)) +
  geom_line()


View(who4)

## I will submit CH13 ASAP <Hutaf>
