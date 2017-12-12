require 'poker_card'

RSpec.describe 'Card' do
  describe 'constructor' do
    context 'when arguments are valid' do
      test_cases = [['heart', 'ace' ,:heart, :ace], ['spade', 'JACK', :spade, :jack]]
      test_cases += [['club', 'Queen', :club, :queen], ['diamond', 'king', :diamond, :king]]
      test_cases += [['heart', 2, :heart, :'2'], ['spade', 3, :spade, :'3'], ] 
      test_cases += [['club', '9', :club, :'9' ], ['diamond', '10', :diamond, :'10']]

      test_cases.each do |values|
        it 'sets instance variable values correctly' do
          card = PokerCard.new(values[0], values[1])
          expect(card.suit).to eq(values[2])
          expect(card.face_value).to eq(values[3])
        end
      end
    end
    context 'when arguments are invalid' do
      invalid_args_type = [['2' 'heart'], ['spade' '3.0'], ['club', [4]]]
      invalid_args_value = [['heart' '-1'], ['heart', '0'], ['heart', '1'], ['spade', '11'], ['club', '12'], ['diamond', 13]]
      invalid_args_value += [['squre', '5'], ['rectangle' 'jack']]
      invalid_args = invalid_args_type + invalid_args_value
      invalid_args.each do |suit, face_value|
        it 'raises ArgumentError' do
          expect { PokerCard.new(suit, face_value) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  before(:each) { @card = PokerCard.new('spade', 'ace')}

  describe '#sanitize_argument?' do
    args_syms = [['ace', :ace], ['Jack', :jack], ['QUEEN', :queen], ['king', :king], [2, :'2'] , [10, :'10']]
    args_syms.each do |arg, sym|
      it 'returns a lowercased and symbolized value for the given arg' do
        expect(@card.sanitize_argument(arg)).to eq(sym)
      end
    end
  end

  describe '#valid_suit?' do
    context 'when given a valid suit' do
      valid_suits = %i[heart spade club diamond]
      valid_suits.each do |suit|
        it 'returns true' do
          expect(@card.valid_suit? suit).to be true
        end
      end
    end
    context 'when given a invalid suit' do
      invalid_suits = %i[hear spad clu diamon 123 -123]
      invalid_suits.each do |suit|
        it 'returns false' do
          expect(@card.valid_suit? suit).to be false
        end
      end
    end
  end

  describe '#valid_face_value?' do
    context 'when given a valid face value' do
      valid_values = %i[ace 2 3 4 5 6 7 8 9 10 jack queen king]
      valid_values.each do |value|
        it 'returns true' do
          expect(@card.valid_face_value? value).to be true
        end
      end
    end
    context 'when given a invalid face value' do
      invalid_values = %i[1 11 12 13 one two ten eleven twelve thirteen]
      invalid_values.each do |value|
        it 'returns false' do
          expect(@card.valid_face_value? value).to be false
        end
      end
    end
  end

end
