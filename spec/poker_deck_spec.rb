require 'poker_deck'

RSpec.describe 'PokerDeck' do
  describe 'constructor' do
    before(:each) { @poker_deck = PokerDeck.new }
    it 'creates a deck with 52 unique cards' do
      expect(@poker_deck.count).to eq(52)
    end
    it 'has 13 cards (ace, 2-10, j, q, k) for each of the suit (heart, spade, club, diamond)' do
      deck_string = "heart ace, heart 2, heart 3, heart 4, heart 5, heart 6, heart 7, heart 8, heart 9, heart 10, heart jack, heart queen, heart king, "
      deck_string += "spade ace, spade 2, spade 3, spade 4, spade 5, spade 6, spade 7, spade 8, spade 9, spade 10, spade jack, spade queen, spade king, "
      deck_string += "club ace, club 2, club 3, club 4, club 5, club 6, club 7, club 8, club 9, club 10, club jack, club queen, club king, "
      deck_string += "diamond ace, diamond 2, diamond 3, diamond 4, diamond 5, diamond 6, diamond 7, diamond 8, diamond 9, diamond 10, diamond jack, diamond queen, diamond king"
      expect(@poker_deck.to_s).to eq(deck_string)
    end
  end

  describe '#deal_card' do
    before(:each) { @deck = PokerDeck.new }
    it 'returns an array containing the card "diamond king" from a newly created and unshuffled deck' do
      card_array = @deck.deal_card
      expect(card_array[0].to_s).to eq('diamond king')
    end
    it 'returns an array containing the first 5 cards from a newly created and unshuffled deck' do
      card_array = @deck.deal_card(5)
      dealt_correctly = card_array[0].to_s == 'diamond king'
      dealt_correctly &&= card_array[1].to_s == 'diamond queen'
      dealt_correctly &&= card_array[2].to_s == 'diamond jack'
      dealt_correctly &&= card_array[3].to_s == 'diamond 10'
      dealt_correctly &&= card_array[4].to_s == 'diamond 9'
      expect(dealt_correctly).to be true
    end
    it 'decrement deck card count by the number of cards dealt' do
      expect { @deck.deal_card(5) }.to change{ @deck.count }.from(52).to(47)
    end
    it 'raises error when there are not enough cards to be dealt' do
      expect { @deck.deal_card(53) }.to raise_error(NotEnoughCardError)
    end
    it 'returns an empty array when asked to dealt 0' do
      expect(@deck.deal_card(0)).to be_empty
    end
    it 'returns an empty array when asked to dealt less than 0 cards' do
      expect(@deck.deal_card(-1)).to be_empty
    end
  end

  describe '#empty?' do
    before(:each) { @deck = PokerDeck.new }
    it 'returns false when the deck has 52 cards left' do
      expect(@deck.empty?).to be false
    end
    it 'returns false when the deck has 1 card left' do
      @deck.deal_card(51)
      expect(@deck.empty?).to be false
    end
    it 'returns true when the deck has 0 card left' do
      @deck.deal_card(52)
      expect(@deck.empty?).to be true
    end
  end

  describe '#shuffle' do
    deck1 = PokerDeck.new(Random.new(1))
    deck2 = PokerDeck.new(Random.new(1))
    deck1.shuffle
    deck2.shuffle

    it 'shuffles the deck to same order when the seeds used to create the deck are the same' do
      expect(deck1.to_s).to eq(deck2.to_s)
    end
  end

end
