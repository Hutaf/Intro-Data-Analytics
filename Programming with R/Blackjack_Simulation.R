deck <- read.csv("/cloud/project/deck.csv")
# Assign deck to Blackjack dataframe
Blackjack <- deck
View(Blackjack)

# Assign facecards the value of 10
facecard<-c("king","queen","jack")
Blackjack$value[Blackjack$face %in% facecard]
Blackjack[Blackjack$face %in% facecard,]
Blackjack$value[Blackjack$face %in% facecard]<-10

#Assign aces the value of NA
Blackjack$value[Blackjack$face == "ace"]<-NA
View(Blackjack)

# Shuffle decks
shuffle<-function(deck){
  deck[sample(1:52,52),]
}
#head(shuffle(deck))

Blackjack <- shuffle(Blackjack)

Hand_Score<- function(analyzedhand){
  score<- sum(analyzedhand$value)
  # Check for an Ace 
  if (sum(analyzedhand$face == "ace")>0){
    if(sum(analyzedhand$value,na.rm = TRUE)>10){
      score<-sum(analyzedhand$value,na.rm = TRUE) + 1
    }else{
      score<-sum(analyzedhand$value,na.rm = TRUE) + 11
    }
  }
  return(score)
}
inx

Basic_Strategy <- function(hand, cards, inx){
  ncards <- length(cards[,1])
  stand <- FALSE
  while (stand != TRUE) {
    score <- Hand_Score(hand)
    # else if hand is <= 16, take another card
    if (score < 17) {
      inx <- inx + 1
      hand <- c(hand, cards[inx,])
    } else {
      stand <- TRUE}
  } # end while stand != TRUE
  return(c(score, inx))
}

play <- function(cards){
  # the number of cards to be played
  ncards <- length(cards[,1])
  inx <- 0
  # winnings 
  winnings <- 0
  while (inx < ncards) {
    # New hand needed: check to see whether at least 4 cards remain unused
    if (inx <= (ncards - 4)) {
      
      # Deal 2 cards to player and dealer then increment card index
      inx <- inx + 2 
      player_hand <- c(cards[inx-1,], cards[inx,])
      inx <- inx + 2
      dealer_hand <- c(cards[inx-1,], cards[inx,])
    } 
    else {
      return(winnings)}
    
    # Play Strategy
    player_res <- Basic_Strategy(player_hand, cards, inx)
    inx <- player_res[2]
    if (player_res[1] <= 21) {
      dealer_res <- Basic_Strategy(dealer_hand, cards, inx)
      inx <- dealer_res[2]
    }
  winnings<- ( player_res[1] > dealer_res[1] & player_res[1] > 21) * 1.5 + # Blackjack
  winnings<-   ( player_res[1] > dealer_res[1] & player_res[1] <= 21) * 1 +  # win
  winnings<-   ( player_res[1]< dealer_res[1] |  player_res[1] == 0) * -1    # lose
  return(winnings)}}

# set 10000 of simulation iterations
iters <- 10000
res <- data.frame(N = 1:iters, winnings = numeric(iters))
for (x in 1:iters) {
  cards <- shuffle(Blackjack)
  res$winnings[i] <- play(cards)
}

#Plot all resluts
plot(res)
hist(res)

# Couldn't run the entire code on RStudio Cloud due to 
# server error (Error: Status code 500 returned)

