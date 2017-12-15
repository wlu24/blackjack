require 'blackjack_game'

RSpec.describe 'BlackjackGame' do
  describe 'constructor' do
    context 'when the player does not start with a blackjack (initialize game with seed = 1)' do
      # seed 1 starting hands:
      #   player: club queen, diamond 5
      #   dealer: heart king
      game = BlackjackGame.new(Random.new(1))
      it 'deals "club queen" and "diamond 5" to player' do
        expect(game.player_hand.to_s).to eq('club queen, diamond 5')
      end
      it 'deals "heart king" to dealer' do
        expect(game.dealer_hand.to_s).to eq('heart king')
      end
      it 'has 49 cards left in the deck after dealing cards' do
        expect(game.deck_count).to eq(49)
      end
      it 'returns false when asked if player has blackjack' do
        expect(game.player_has_blackjack).to be false
      end
    end
    context 'when the player starts with a blackjack (initialize game with seed = 87)' do
      # seed 87 starting hands:
      #   player: club king, spade ace    (blackjack)
      #   dealer: spade 3, heart 7        (dealer gets an extra card because player got blackjack)
      game = BlackjackGame.new(Random.new(87))
      it 'deals "club king" and "spade ace" to player' do
        expect(game.player_hand.to_s).to eq('club king, spade ace')
      end
      it 'deals "spade 3" and "heart 7" to dealer' do
        expect(game.dealer_hand.to_s).to eq('spade 3, heart 7')
      end
      it 'has 48 cards left in the deck after dealing cards' do
        expect(game.deck_count).to eq(48)
      end
      it 'returns true when asked if player has blackjack' do
        expect(game.player_has_blackjack).to be true
      end
    end
  end
  
  describe '#game_status' do
    context 'when player gets blackjack' do
      before(:each) do
        @game = BlackjackGame.new
        allow(@game).to receive(:player_score).and_return(21)
        allow(@game).to receive_message_chain(:player_hand, :blackjack?).and_return(true)
      end
      it 'returns :player_win if dealer score < 21' do
        allow(@game).to receive(:dealer_score).and_return(20)
        expect(@game.game_status).to eq(:player_win)
      end
      it 'returns :player_win if dealer score 21 but does not have blackjack' do
        allow(@game).to receive(:dealer_score).and_return(21)
        allow(@game).to receive_message_chain(:dealer_hand, :blackjack?).and_return(false)
        expect(@game.game_status).to eq(:player_win)
      end
      it 'returns :tie if dealer also gets blackjack' do
        allow(@game).to receive(:dealer_score).and_return(21)
        allow(@game).to receive_message_chain(:dealer_hand, :blackjack?).and_return(true)
        expect(@game.game_status).to eq(:tie)
      end
    end
    context 'when player does not get blackjack' do
      before(:each) do
        @game = BlackjackGame.new
        allow(@game).to receive_message_chain(:player_hand, :blackjack?).and_return(false)
      end
      it "returns :player_turn when player's score is < 21 and hasn't 'stand' yet" do
        allow(@game).to receive(:player_score).and_return(20)
        expect(@game.game_status).to eq(:player_turn)
      end
      it "returns :dealer_win when player busts (score > 21)" do
        allow(@game).to receive(:player_score).and_return(22)
        expect(@game.game_status).to eq(:dealer_win)
      end
      context "when player request to 'stand' (end turn)" do
        before(:each) do
          @game = BlackjackGame.new
          @game.player_request_stand
          allow(@game).to receive_message_chain(:player_hand, :blackjack?).and_return(false)
          @game.instance_variable_set(:@player_has_blackjack, false)
        end
        it "expects dealer's hand to be resolved" do
          expect(@game).to receive(:resolve_dealer_hand)
          @game.game_status
        end
        it 'returns :player_win when dealer busts' do
          allow(@game).to receive(:dealer_score).and_return(22)
          expect(@game.game_status).to eq(:player_win)
        end
        it 'returns :dealer_win if dealer gets blackjack' do
          allow(@game).to receive(:dealer_score).and_return(21)
          allow(@game).to receive_message_chain(:dealer_hand, :blackjack?).and_return(true)
          allow(@game).to receive(:player_score).and_return(21)
          expect(@game.game_status).to eq(:dealer_win)
        end
        it 'returns :tie if dealer and player get 21 but no one got blackjack' do
          allow(@game).to receive(:dealer_score).and_return(21)
          allow(@game).to receive_message_chain(:dealer_hand, :blackjack?).and_return(false)
          allow(@game).to receive(:player_score).and_return(21)
          expect(@game.game_status).to eq(:tie)
        end
        it 'returns :tie if dealer and player get same score which is below 21' do
          allow(@game).to receive(:dealer_score).and_return(17)
          allow(@game).to receive(:player_score).and_return(17)
          expect(@game.game_status).to eq(:tie)
        end
        it 'returns :player_win if player score > dealer score' do
          allow(@game).to receive(:dealer_score).and_return(18)
          allow(@game).to receive(:player_score).and_return(20)
          expect(@game.game_status).to eq(:player_win)
        end
        it 'returns :dealer_win if dealer score > player score' do
          allow(@game).to receive(:dealer_score).and_return(18)
          allow(@game).to receive(:player_score).and_return(16)
          expect(@game.game_status).to eq(:dealer_win)
        end
      end
    end
  end
end
