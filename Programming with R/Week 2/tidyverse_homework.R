# Section 3.2.4
#1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
## Answer: Nothing plotted, because because we have specified neither the mapping and plot type

#2. How many rows are in mpg? How many columns?
dim(mtcars)  
## Answer: 32 rows, 11 columns

#3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
## Answer: the type of drive train, 
## where f = front-wheel drive, r = rear wheel drive, 4 = 4wd

#4. Make a scatterplot of hwy vs cyl.
ggplot(data = mpg)+ geom_point(mapping = aes(x= hwy, y= cyl))

#5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))
## Answer: Both variables are categorical, which makes the plot unuseful because
## it gives us only a combinations of these variables 

##################################################################
# Section 3.3.1
#1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
## Answer: because the color argument must be placed outside the aes() argument
## Correction:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). 
#   How can you see this information when you run mpg?
head(mpg, 5)
## Answer:The information is shown under the column names in the dataframe 

#3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cyl))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = drv))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = displ)
## Answer:  For continuous variables a scale of numbers is shown, and the category names for discrete variables
## ggplot throw an error message if we map a continuous variables to shape.
## Also, ggplot shown a warning message if e map a discrete variable (e.g., drv) to size.

#4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = drv,  color = drv))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cyl, color = cyl))
## Answer: both are applied, as long as the aesthetics are compatible with variable type

#5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
?geom_point
vignette("ggplot2-specs")
## Answer: shapes 21-24 have both stroke colour and a fill. The size of the filled part is controlled by size, the size of the stroke is controlled by stroke.

#6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5))

## Answer: As shown in the plot, the asethtics are applied to the evaluated value (displ < 5)

###########################################################
# Section 3.5.1
# 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ displ, nrow = 3)
##Answer: The above plot shows hwy vs displ scatter plots facetted by displ,
##        there is one facet for each unique value on displ.

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))+
  facet_grid(drv ~ cyl)
## Answer: The empty cells in the above plot mean there are no observations in those particular combinations of (drv vs cyl)

  # 3. What plots does the following code make? What does . do?
  
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
## Answer: the above plot tell us that rows are facetted by drv, and no facetting by columns
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
## Answer: the above plot tell us that columns are facetted by cyl, and no facetting by rows

# 4. Take the first faceted plot in this section:
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
#What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
## Answer: 
## 1. With faceting it is easier to examine the indivual plots to avoid the confusion comes with several colors in a single plot. 
## 2. With coloring it is easier to compare between classes directly.
## 3. With larger datasets it's better to use coloring to see an overall clustering. 
  
# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?
?facet_wrap
## Answer:	
## nrow, ncol: Number of rows and columns.
## scales:    should Scales be fixed ("fixed", the default), free ("free"), or free in one dimension ("free_x", "free_y").
## shrink:    If TRUE, will shrink scales to fit output of statistics, not raw data. If FALSE, will be range of raw data before statistical summary.
## Facet grids do not have nrow and ncol arguments because the rows and columns are determined by the attributes (... ~ ...)
  
# 6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?
## Answer: Because if there are many levels, we will have many panels in the rows.

#################################################################
# Section  3.6.1 
# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
## Answer: Line chart: geom_line(),  boxplot: geom_boxplot(), histogram: geom_histogram(), and area chart: geom_area().
  
# 2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
    geom_point() + 
    geom_smooth(se = FALSE)
  
# 3. What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it earlier in the chapter?
  ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, color = drv),show.legend = FALSE)
## Answer: show.legend = FALSE hides the legned 
## removing this argument will always result in show the legend
## Not exactly sure why they used it earlier.

# 4. What does the se argument to geom_smooth() do?
?geom_smooth()
## Answer:  Display confidence interval around smooth? (TRUE by default, see level to control.)
  
# 5. Will these two graphs look different? Why/why not?
 
    ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() + 
    geom_smooth()
  
  ggplot() + 
    geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

## Answer: They look same, in the first code, data and mapping are both defined in ggplot() 
## and are carried over to the geoms. In the second code, data and mapping are defined individually in each geom.

# 6. Recreate the R code necessary to generate the following graphs.
## Answer: first graph
  first <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_smooth(se = FALSE, show.legend = FALSE)

  second <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_smooth(mapping = aes(group = drv), se = FALSE, show.legend = FALSE)

  third <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + 
    geom_point() +
    geom_smooth(se = FALSE)

  fourth <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping = aes(color=drv)) +
    geom_smooth(se = FALSE)
  
## still working on fifth and sixth graphs

##################################################################
# Section 3.7.1
# 1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?
  ggplot(data = diamonds) + 
    stat_summary(
      mapping = aes(x = cut, y = depth),
      fun.ymin = min,
      fun.ymax = max,
      fun.y = median
    )
  
## using geom_pointrange
?geom_pointrange  
  
ggplot(data = diamonds) + 
  stat_summary(
  mapping = aes(x = cut, y = depth),
  fun.ymin = min,
  fun.ymax = max,
  fun.y = median
    )  
## Answer: The default geom for stat_summary() is geom_pointrange

# 2. What does geom_col() do? How is it different to geom_bar()?
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) + 
  geom_col()

ggplot(data = diamonds, mapping = aes(x = cut)) + 
  geom_bar()

## Answer: Both geom_col() and geom_bar() create bar charts.
##         The main difference is that for geom_bar(), the default is stat_count() 

# 3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?
## Answer: Still reading (https://ggplot2.tidyverse.org/reference/)

# 4. What variables does stat_smooth() compute? What parameters control its behaviour?
?stat_smooth

## Answer: stat_smooth calculates multiple args
## depend on the smoothing method passed in method attrbutes to computes different args such as se, ymax, and ymin

# 5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
## first problem
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
## to solve this
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
## second problem
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
## To solve this
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..,group=1))
## Why? All the bars have prop == 1, If group is not set to 1.
################################################################
# Section 3.8.1
# 1. What is the problem with this plot? How could you improve it?
    
    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_point()
  
## geom_point() overlaps some point, which make the graph look like this 
## to solve this, I used geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()
# 2. What parameters to geom_jitter() control the amount of jittering?
?geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter(width = 1, height = 3)
## Answer: Width and Height args are controlling the amount of vertical and horizontal jitter.
# 3. Compare and contrast geom_jitter() with geom_count().
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_count()

## Answer: Both can represent data points, but geom_count() increases the size of the points when there are more overlapping points 

# 4. What’s the default position adjustment for geom_boxplot()? Create a visualisation of the mpg dataset that demonstrates it.
?geom_boxplot()

ggplot(data = mpg, mapping = aes(x = drv, y = hwy) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = drv, y = hwy)) +
  geom_boxplot(position = "dodge")

## Answer: The default position adjustment is dodge.
