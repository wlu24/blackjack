require_relative 'blackjack_hand'
require_relative 'poker_deck'

# A class to represent a 2 player (a dealer and a player) blackjack game
#
# game flow:
#
# when the game begins, player is dealt 2 cards and dealer is dealt 1 card then it goes to player's turn
# when in player's turn, player can either "hit" or "stand"
# player's turn ends when player gets a score of 21 or goes bust or "stand"
# once player's turn ends, resolve dealer's hand
#   dealer continues to draw cards until his score reaches 17 or above
# compare scores and determine who is the winner
#
#
#
# rules for determining who is the winner:
#
# dealer wins if player busts
#             if dealer score > player score
#             if tie score but dealer has blackjack and player doesn't
# player wins if dealer busts
#             if player score > dealer score
#             if tie score but player has blackjack and dealer doesn't
# game tie    if tie score or both have blackjack

class BlackjackGame
  DEALER_RESOLVE_VALUE = 17

  attr_reader :dealer_hand, :player_hand, :player_ended_turn, :player_has_blackjack

  def initialize(seed = Random.new)
    @player_ended_turn = false
    @player_has_blackjack = false

    @dealer_hand = BlackjackHand.new
    @player_hand = BlackjackHand.new
    @poker_deck = PokerDeck.new(seed)
    @poker_deck.shuffle

    @player_hand.add_cards(@poker_deck.deal_card(2))
    @dealer_hand.add_cards(@poker_deck.deal_card)

    if @player_hand.blackjack?
      @player_has_blackjack = true
      @dealer_hand.add_cards(@poker_deck.deal_card)
      # if dealer did not get blackjack here, player wins since blackjack beats non blackjacks
      # game result determined in #game_status
    end
  end

  def player_request_hit
    @player_hand.add_cards(@poker_deck.deal_card)
  end

  def player_request_stand
    @player_ended_turn = true
  end

  def resolve_dealer_hand
    @dealer_hand.add_cards(@poker_deck.deal_card) while dealer_score < 17
  end

  def game_status
    return :dealer_win if player_score > 21

    # invariant at this stage: player_score <= 21
    @player_ended_turn = true if player_score == 21
    return :player_turn unless @player_ended_turn # player request 'stand' or player has a score of 21

    # invariant at this stage: player_score <= 21 && player_ended_turn
    resolve_dealer_hand unless @player_has_blackjack # dealer's hand resolved in constructor if @player_has_blackjack
    return :player_win if dealer_score > 21

    # invariant at this stage: player_score <= 21 && dealer_score <= 21 AND both turn ended (no more cards will be dealt from deck)
    if dealer_score == player_score
      dealer_blackjack = dealer_hand.blackjack?
      player_blackjack = player_hand.blackjack?
      return :tie if dealer_blackjack && player_blackjack
      return :dealer_win if dealer_blackjack
      return :player_win if player_blackjack
      return :tie
    end

    # invariant at this stage: 
    #   player_score <= 21 && dealer_score <= 21 && dealer_score != player_score
    #   AND both turn ended (no more cards will be dealt from deck)
    dealer_score > player_score ? :dealer_win : :player_win
  end

  def dealer_hand_count
    @dealer_hand.count
  end

  def player_hand_count
    @player_hand.count
  end

  def deck_count
    @poker_deck.count
  end

  def dealer_score
    @dealer_hand.score
  end

  def player_score
    @player_hand.score
  end
  
  def print_game_state
    puts "Dealer's hand (score: #{dealer_score}):\n\n"
    @dealer_hand.each { |card| puts card.to_s }
    
    puts "\n\n"
    
    puts "Player's hand (score: #{player_score}):\n\n"
    @player_hand.each { |card| puts card.to_s }
    
    puts "\n---------------------------------------------\n"
    
  end
end
