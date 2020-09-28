
get_symbols <- function() {
  wheel <- c("DIAMOND", "7", "BAR BAR BAR", "BAR BAR", "BAR",  "CHERRY", "0")
  sample(wheel, size = 3, replace = TRUE, 
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

score <- function (symbols) {
  # identify case
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("BAR", "BAR BAR", "BAR BAR BAR")
  # get prize
  if (same) {
    payouts <- c("DIAMOND" = 100, "7" = 80, "BAR BAR BAR" = 40, "BAR BAR" = 25, 
                 "BAR" = 10, "CHERRY" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <- 5
  } else {
    cherries <- sum(symbols == "CHERRY")
    prize <- c(0, 2, 5)[cherries + 1]
  }
  
  diamonds <- sum(symbols == "DIAMOND")
  prize * 2 ^ diamonds
}

score_total <- 0

play <- function(){
  total <- 0
  symbols <- get_symbols()
  print(symbols)
  cat("Your prize is:",score(symbols),"$" ,sep=" ",fill=TRUE)
  total <- total + score(symbols)
  assign("score_total", total,envir = globalenv())
  
}

cat("Welcome to the Slot Machine Simulator
You'll be asked if you want to play.
Answer with  y or n")

user.input <- readline(prompt="Do you want to play? (y/n)")

sum<- 0
while(user.input == "y"){
  play()
  sum<- sum + score_total 
  user.input <- readline(prompt="Do you want to play? (y/n)")}

cat("You ended the game with $", sum, " in your hand.", sep=" ",fill=TRUE)

