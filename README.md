# blackjack
A simple blackjack game. Practicing TDD.

To play the game at terminal, run `$ruby play.rb` at the root directory of blackjack.

### Rules for determining the winner

* __Dealer wins if__

  * player busts

  * dealer score > player score

  * tie score but dealer has blackjack and player doesn't
  
* __Player wins if__
  
  * dealer busts
  
  * player score > dealer score
  
  * tie score but player has blackjack and dealer doesn't
  
* __Game ties otherwise__