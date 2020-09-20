First_dice <- 1:10
Second_dice <- 1:20

Prob1 = c(1/10,1/10,1/10,1/10,1/10,1/10,1/10,1/10,1/10,1/10)
Prob2 = c(1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20,
          1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20,1/20)
sum(Prob1)
sum(Prob2)

# First Function 
First_Fun <- function(die, probability){
  rolls <- sample(die, size = 6, replace=TRUE, prob = probability)
  sum(rolls)
  #print(rolls)
}

# Calling roll function for the first dice
First_Fun(First_dice, Prob1)
# Calling roll function for the second dice
First_Fun(Second_dice , Prob2)

# Second Function
Second_Fun <- function(die, probability, Condition){
rolls <- sample(die, size = 6, replace=TRUE, prob = probability)
count <- length(which(rolls>Condition))
print(rolls)
return(count)}

# Calling second function for the first dice
Second_Fun(First_dice, Prob1, 6)
# Calling second function for the second dice
Second_Fun(Second_dice , Prob2, 16)
