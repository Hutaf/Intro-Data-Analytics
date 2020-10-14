library(expm)
library(diagram)

### Case Study ###

## Memoryless bar, on the other hand, is tired of running out of inventory and 
## missing a lot of potential sales. They have hired you to help them figure out
## what they need to do to have a probability of 60% or higher of having 2 kegs on 
## hand in the long run. There are several things that you can change to attempt 
## this task: changing the order rules, expanding the chain to allow for more inventory to accumulate.
## Experiment with a few of these and make a recommendation to the bar owners,
## your recommendation should include a diagram, a transition matrix, and the steady-state values


### Recommendations ###

## Create transition matrix with changing the order rules in order to make some improvements
T <- matrix(c(c(0.2,0,0.8,0,0,0,0.6,0.4,0.05,0,0.75,0.2,0.2,0,0.6,0.2)), nrow = 4, byrow = TRUE)
colnames(T) = c(0,1,2,3)
rownames(T) = c(0,1,2,3)


# Plot a Diagram of the transition matrix
plotmat(T,pos = c(3,1),
        lwd = 1, box.lwd = 1,
        cex.txt = 0.8,
        box.size = 0.1,
        box.type = "ellipse",
        box.prop = 0.4,
        box.col = "light blue",
        arr.length=.1,
        arr.width=.1,
        self.cex = .4,
        self.shifty = -.07,
        self.shiftx = .10,
        main = "")

# Print transition matrix
print("Transition Matrix")
print(T)

# Print steady state
print("Steady State")
print(T%^%15)
print(T%^%20)

