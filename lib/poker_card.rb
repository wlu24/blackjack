# A class representing a poker card
# A poker card has a suit value and a face value
# Valid suit values include heart, spade, club, and diamond
# Valid face values include ace, 2 to 10, jack, queen, and king
class PokerCard
  VALID_SUITS = %i[heart spade club diamond].freeze
  VALID_FACE_VALUE = %i[ace 2 3 4 5 6 7 8 9 10 jack queen king].freeze

  attr_reader :suit, :face_value

  def initialize(suit, face_value)
    suit = sanitize_argument(suit)
    face_value = sanitize_argument(face_value)
    raise(ArgumentError, 'Invalid suit') unless valid_suit? suit
    raise(ArgumentError, 'Invalid face value') unless valid_face_value? face_value
    @suit = suit
    @face_value = face_value
  end

  def sanitize_argument(arg)
    arg.to_s.downcase.to_sym
  end

  def valid_suit?(suit)
    VALID_SUITS.include? suit
  end

  def valid_face_value?(face_value)
    VALID_FACE_VALUE.include? face_value
  end

  def to_s
    "#{@suit} #{@face_value}"
  end
end
