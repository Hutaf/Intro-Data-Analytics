install.packages("lpSolve")

library("lpSolve")

# Hopatronics IPA: it uses 5 pounds of Corn, 4 ounces of hops and 35 pounds of Malt, 5 hours.
# American Kolsch: it uses 15 pounds of Corn, 4 ounces of hops and 20 pounds of Malt, 10 hours.
# Barrel-Aged Dantzig: It uses 10 pounds of corn, 4 oz of hops and 15 pounds of malt, 20 hours.
# Hopatronic IPA, American Kolsch, and Dantzig, it have margins of $13, $23, and $30 profit respectively.
# Assuming that the full time employment is 8 hours per day, which means each employee work for 
# 240 hours per month and we have 5 employee, so the total hour of labor per month is 1200.

f.obj <- c(13, 23, 30)


# Each row represent Corns, Hops, Malt, Hours.
f.con <- matrix(c(5,15,10,
                  4,4,4,
                  35,20,15,
                  5, 10, 20), nrow = 4, byrow = TRUE)

# Create a list of directions
f.dir <- c("<=","<=","<=", "<=")

# Create a list of right hand side for the constraints
f.rhs <- c(4800,150,1190, 1200)

sol <- lp("max", f.obj, f.con, f.dir, f.rhs,compute.sens = TRUE)


# Compute optimum value for each beer
Best_sol <- sol$solution
names(Best_sol) <- c("Hopatronics IPA", "American Kolsch", "Dantzig") 
print(Best_sol)

# Check the value of objective function at optimal point
cat("Total cost: ", sol$objval, sep="")


sol$duals