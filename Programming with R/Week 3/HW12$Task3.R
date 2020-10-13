#### Task 3 ####
library("tidyverse")

### Simulating sampling from a box of fruits then calculate the joint prbability ###
### marginal probability, and conditional probability ###

# This is a vector representing a box of fruits (4 Oranges, 3 Bananas, 3 Apples). 
fruits_box <- c("Orange", "Orange", "Orange", "Orange",
         "Apple", "Apple", "Apple",
         "Banana", "Banana", "Banana")


# This function simulates drawing 3 fruits at a time from the box without replacement 
# and computing the total number of x and y selected
# Where x = number of Oranges selected, y = number of Apples selected.
sampling <- function(){
  fruits <- sample(fruits_box, size = 3, replace = FALSE)
  Orange <- sum(fruits == "Orange")
  Apple <- sum(fruits == "Apple")
  c(Orange, Apple)
}

# The replicate() function simulates this sampling process 100 times,
# storing the outcomes in the data frame results with variable names Orange and Apple.
results <- data.frame(t(replicate(100, sampling())))
names(results) <- c("Orange", "Apple")
results

# The results table divided by 100 to calculate the joint probability 
joint <- table(results$Orange, results$Apple) / 100
joint

# Converting table back to dataframe
# joint_data <- as.data.frame.matrix(joint) 
# joint_data


# P(X=A) = sum P(X=A, Y=yi) for all y
cbind(joint, marginal = rowSums(joint))

# P(A given B) = P(A and B) / P(B)
# What is the prob of apple is selected once, given that orange is selected once?
(Conditional_prob <- results %>% 
  filter(Orange == 1) %>% 
  group_by(Apple) %>% 
  summarize(N = n()) %>% 
  mutate(Prob = N / sum(N)))

# Check if the probability is equal to one 
sum(Conditional_prob$Prob)

# What is the prob of orange is selected once, given that apple is selected twice?
(Conditional_prob2 <- results %>% 
    filter(Apple == 2) %>% 
    group_by(Orange) %>% 
    summarize(N = n()) %>% 
    mutate(Prob = N / sum(N)))

# Check if the probability is equal to one 
sum(Conditional_prob2$Prob)


