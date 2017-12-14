require 'blackjack_hand'

RSpec.describe 'BlackjackHand' do
  describe 'constructor' do
  end

  describe '#add_card' do
    it 'adds the given card to hand' do
      @hand = BlackjackHand.new
      card = PokerCard.new('spade', 'ace')
      expect { @hand.add_card(card) }.to change { @hand.count }.from(0).to(1)
      card2 = PokerCard.new('spade', 'jack')
      expect { @hand.add_card(card2) }.to change { @hand.count }.from(1).to(2)
    end
  end

  describe '#add_cards' do
    it 'adds the given cards to hand' do
      @hand = BlackjackHand.new
      cards = [PokerCard.new('spade', 'ace'), PokerCard.new('heart', 2), PokerCard.new('club', 'queen')]
      expect { @hand.add_cards(cards) }.to change { @hand.count }.from(0).to(3)
    end
  end

  describe '#score' do
    tests = []
    # cases with no ace
    tests.push({hand: [], score: 0})
    tests.push({hand: [['diamond', 'queen'], ['diamond', 'king']], score: 20})
    # cases with one ace where its best value is 11
    tests.push({hand: [['spade', 'ace']], score: 11})
    tests.push({hand: [['heart', 'ace'], ['club', 'jack']], score: 21})
    # cases with one ace where its best value is 1
    tests.push({hand: [['club', 'ace'], ['spade', 5], ['heart', 6]], score: 12})
    tests.push({hand: [['spade', 2], ['diamond', 'ace'], ['heart', 10]], score: 13})
    tests.push({hand: [['spade', 'jack'], ['heart', 'queen'], ['diamond', 'ace']], score: 21})
    # cases with multiple aces where one of them has 11 as best value
    tests.push({hand: [['spade', 'ace'], ['heart', 'ace']], score: 12})
    tests.push({hand: [['spade', 'ace'], ['heart', 'ace'], ['diamond', 'ace']], score: 13})
    # cases with multiple aces where all aces' value should be 1
    tests.push({hand: [['spade', 4], ['club', 'ace'], ['heart', 7], ['diamond', 'ace']], score: 13})
    tests.push({hand: [['club', 'ace'], ['spade', 3], ['heart', 9], ['diamond', 'ace']], score: 14})
    tests.push({hand: [['club', 'ace'], ['spade', 3], ['heart', 9], ['diamond', 'ace']], score: 14})
    # cases with score over 21
    tests.push({hand: [['heart', 'jack'], ['club', 'queen'], ['diamond', 'king']], score: 30})
    tests.push({hand: [['spade', 7], ['club', 7], ['heart', 8]], score: 22})
    tests.push({hand: [['spade', 7], ['club', 7], ['diamond', 'ace'], ['heart', 7]], score: 22})

    tests.each do |single_test|
      it 'returns the correct score with the given hand' do
        hand = BlackjackHand.new
        single_test[:hand].each do |args|
          hand.add_card(PokerCard.new(args[0], args[1]))
        end
        expect(hand.score).to eq(single_test[:score])
      end
    end
  end

  describe '#busted?' do
    before(:each) { @hand = BlackjackHand.new }
    it 'returns false when score is 0' do
      expect(@hand.busted?).to be false
    end
    it 'returns false when score is 2' do
      @hand.add_card(PokerCard.new('spade', 2))
      expect(@hand.busted?).to be false
    end
    it 'returns false when score is 21' do
      @hand.add_cards([PokerCard.new('spade', 'jack'), PokerCard.new('spade', 'ace')])
      expect(@hand.busted?).to be false
    end
    it 'returns true when score is 22' do
      @hand.add_cards([PokerCard.new('club', 'jack'), PokerCard.new('club', 10), PokerCard.new('club', 2)])
      expect(@hand.busted?).to be true
    end
  end

  describe '#blackjack?' do
    context 'when having blackjack' do
      before(:each) { @hand = BlackjackHand.new }
      blackjacks = [%w(club ace club king), %w(heart queen spade ace), %w(diamond jack heart ace), %w(diamond ace club 10)]
      blackjacks.each do |args|
        it 'returns true' do
          @hand.add_cards([ PokerCard.new(args[0], args[1]), PokerCard.new(args[2], args[3]) ])
          expect(@hand.blackjack?).to be true
        end
      end
    end
    context 'when not having blackjack' do
      before(:each) { @hand = BlackjackHand.new}
      it 'returns false when there is only 1 card in hand' do
        @hand.add_cards([PokerCard.new('club', 'ace')])
        expect(@hand.blackjack?).to be false
      end
      it 'returns false when there is 3 cards in hand' do
        @hand.add_cards([PokerCard.new('club', 'jack'), PokerCard.new('heart', 'queen'), PokerCard.new('spade', 'ace')])
        expect(@hand.blackjack?).to be false
      end
      it 'returns false when the 2 cards does not add to 21' do
        @hand.add_cards([PokerCard.new('club', 'jack'), PokerCard.new('heart', 'queen')])
        expect(@hand.blackjack?).to be false
      end
    end
  end

  describe '#to_s' do
    tests = []
    tests.push({cards: [], string_form: 'empty hand'})
    tests.push({cards: [PokerCard.new('spade', 3)], string_form: 'spade 3'})
    tests.push({cards: [PokerCard.new('diamond', 'ace'), PokerCard.new('diamond', 'king')], string_form: 'diamond ace, diamond king'})
    tests.push({cards: [PokerCard.new('club', 3), PokerCard.new('club', 5), PokerCard.new('club', 'jack')], string_form: 'club 3, club 5, club jack'})

    tests.each do |single_test|
      it 'returns cards in string' do
        hand = BlackjackHand.new
        hand.add_cards(single_test[:cards])
        expect(hand.to_s).to eq(single_test[:string_form])
      end
    end
  end

  describe '.card_value' do
    it 'returns 1 and 11 for ace' do
      correct &&= BlackjackHand.card_value(PokerCard.new('heart', 'ace')) == [1, 11]
      correct &&= BlackjackHand.card_value(PokerCard.new('spae', 'ace')) == [1, 11]
      correct = BlackjackHand.card_value(PokerCard.new('club', 'ace')) == [1, 11]
      correct &&= BlackjackHand.card_value(PokerCard.new('diamond', 'ace')) == [1, 11]
      expect(correct).to be true
    end

    context 'when given number cards' do
      hand = [['heart', 2], ['heart', 3], ['heart', 4], ['spade', 5], ['spade', 6]]
      hand += [['club', 7], ['club', 8], ['diamond', 9], ['diamond', 10]]
      hand.each do |args|
        it 'returns natural value of the card' do
          expect(BlackjackHand.card_value(PokerCard.new(args[0], args[1]))).to eq([args[1]])
        end
      end
    end

    context 'when given face cards' do
      hand = [['heart', 'jack'], ['spade', 'queen'], ['club', 'king']]
      hand.each do |args|
        it 'returns 10' do
          expect(BlackjackHand.card_value(PokerCard.new(args[0], args[1]))).to eq([10])
        end
      end
    end
    it 'raises error when the card is invalid' do
      card = double()
      allow(card).to receive(:face_value).and_return(:'1')
      expect { BlackjackHand.card_value(card) }.to raise_error(InvalidCardError)
    end
  end
end