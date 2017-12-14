require_relative 'poker_card'

# A class representing a deck of 52 poker cards
# 4 suits (heart, spade, club, diamond)
# 13 cards per suit (ace, 2-10, jack, queen, king)
class PokerDeck
  def initialize(seed = Random.new)
    @deck = []
    PokerCard.valid_suits.each do |suit|
      PokerCard.valid_face_values.each do |face_value|
        @deck.push(PokerCard.new(suit, face_value))
      end
    end
    @seed = seed
  end

  def shuffle
    @deck = @deck.shuffle(random: @seed)
  end

  def deal_card(number = 1)
    raise NotEnoughCardError if empty? || number > count

    cards_dealt = []
    1.upto(number) { cards_dealt.push(@deck.pop) }
    cards_dealt
  end

  def count
    @deck.length
  end

  def empty?
    @deck.empty?
  end

  def to_s
    return 'empty deck' if empty?
    @deck.map { |card| "#{card.suit} #{card.face_value}" }.join(', ')
  end
end

class NotEnoughCardError < StandardError
  def initialize(msg = 'Not enoguh cards left in the deck')
    super msg
  end
end
