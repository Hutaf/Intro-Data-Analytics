deck <- read.csv("/cloud/project/deck.csv")
View(deck)

# Blackjack Cards
blackjack <- deck
face<- c("king","queen", "jack")
blackjack$value[blackjack$face %in% face]
blackjack[blackjack$face %in% face,]
blackjack$value[blackjack$face %in% face]<-10
blackjack$value[blackjack$face == "ace"]<-NA
View(blackjack)


# hearts Cards
hearts<- deck
hearts$value <- 0
hearts$value[hearts$suit == "hearts"]<- 1
hearts$value[hearts$suit == "spades" & hearts$face == "queen"]<- 13
View(hearts)

# function for shuffling the deck
shuffle <- function(cards){
  assign("deck",cards[sample(1:52, size = 52),], envir = globalenv())}


#function for dealing cards to 2 players in hearts
Hearts_Deal <- function(cards){
  cards[1,]
  assign("Hearts", hearts[-1,], envir = globalenv())}

#function for dealing cards to 2 players and a dealer in blackjack
Blackjack_Deal <- function(cards){
  cards[1,]
  assign("21Deal", blackjack[-1,], envir = globalenv())}


