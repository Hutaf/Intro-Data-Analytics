
# Deal
deal<- function(currentdeck){
  card<-currentdeck[1,]
  assign("playblackjack", currentdeck[-1,],envir = globalenv())
  card
}

playblackjack <-  Blackjack

# Hands
hands<-deal(playblackjack)
hands$player = "p1"
for (i in 1:5){
  newcard <- deal(playblackjack)
  if (i %in% c(1,4)){
    newcard$player<- "p2"
  }else if (i %in% c(2,5)){
    newcard$player<- "dealer"
  }else{
    newcard$player<- "p1"
  }
  hands<-rbind(hands,newcard)}

# Strategy for the dealer
Dealer_Strategy<- function(hands){

score <- score_hand(hands[hands$player == "dealer",])
while(score<17){
  newcard<-deal(playblackjack)
  newcard$player<- "dealer"
  hands<-rbind(hands,newcard)
  score<-score_hand(hands[hands$player == "dealer",])
}
if (sum(hands$values[hands$player == "dealer"],na.rm = TRUE)>10){
  hands$value[hands$player == "dealer" & hands$face=="ace"]<- 1
}else{
  hands$value[hands$player == "dealer" & hands$face=="ace"]<- 11
}
# Check for Blackjack
if (sum(hands$values[hands$player == "dealer"]) == 21){ print("Blackjack")}}

# Strategy for the First player
Player1_Strategy <- function(hands) {
score <- score_hand(hands[hands$player == "p1",])
while(score<17){
   newcard<-deal(playblackjack)
   newcard$player<- "p1"
   hands<-rbind(hands,newcard)
   score<-score_hand(hands[hands$player == "p1",])}
if (sum(hands$value[hands$value == "p1"]) == 0) {return("Stand")}
if (sum(hands$values[hands$player == "dealer"]) > 6 & (sum(hands$value[hands$value == "p1"]) < 17)) {return("Hit")}
else{return("Stand")}

# Check for blackjack
if (sum(hands$values[hands$player == "p1"]) == 21){print("Blackjack")}}

# Strategy for the Second player
Player2_Strategy <- function(hands) {
score <- score_hand(hands[hands$player == "p2",])
while(score<17){
    newcard<-deal(playblackjack)
    newcard$player<- "p2"
    hands<-rbind(hands,newcard)
    score<-score_hand(hands[hands$player == "p2",])}
if (length(which(hands$value[hands$player == "p2"] %in% c(10))) == 2) {return("Stand")}
if (sum(hands$values[hands$player == "dealer"]) > 6  & length(which(hands$value[hands$player == "p2"] %in% c(7))) == 2 ) {return("Hit")}
else{return("Stand")}

# Check for blackjack
if (sum(hands$values[hands$player == "p2"]) == 21){ print("Blackjack")}}

