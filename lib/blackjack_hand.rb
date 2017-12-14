require_relative 'poker_card'

# A class representing a hand of cards in a blackjack game
# Each card is a PokerCard
class BlackjackHand
  attr_reader :hand

  def initialize
    @hand = []
  end

  def add_card(poker_card)
    @hand.push(poker_card)
  end

  def add_cards(array_of_poker_cards)
    @hand += array_of_poker_cards
  end

  def score
    ace_count = 0
    sum = 0

    @hand.each do |card|
      case card.face_value
      when :ace
        ace_count += 1
      when :jack, :queen, :king
        sum += 10
      when :'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :'10'
        sum += card.face_value.to_s.to_i
      else
        raise InvalidCardError, card.to_s
      end
    end

    ace_count.times { sum + 11 > 21 ? sum += 1 : sum += 11 }

    sum
  end

  def busted?
    score > 21
  end

  def blackjack?
    # an ace and a ten-card (10, jack, queen, or king)
    return false unless count == 2

    have_ace = false
    have_ten_card = false
    @hand.each do |card|
      case card.face_value 
      when :ace
        have_ace = true
      when :'10', :jack, :queen, :king
        have_ten_card = true
      end
    end

    have_ace && have_ten_card
  end

  def count
    @hand.length
  end

  def each(&block)
    @hand.each(&block)
  end
  
  def to_s
    return 'empty hand' if @hand.empty?
    @hand.map { |card| "#{card.suit} #{card.face_value}" }.join(', ')
  end

  def self.card_value(poker_card)
    case poker_card.face_value
    when :ace
      return [1, 11]
    when :jack, :queen, :king
      return [10]
    when :'2', :'3', :'4', :'5', :'6', :'7', :'8', :'9', :'10'
      return [poker_card.face_value.to_s.to_i]
    else
      raise InvalidCardError, poker_card.to_s
    end
  end
end

# A custom error to indicate that the given card is invalid
class InvalidCardError < StandardError
  def initialize(msg = 'Not a valid poker card')
    super msg
  end
end
