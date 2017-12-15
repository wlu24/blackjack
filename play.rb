require './lib/blackjack_game.rb'


play_again = true

while play_again
  
  puts "\n\n"
  game = BlackjackGame.new

  while game.game_status == :player_turn
    game.print_game_state
    print "Hit (h) or stand (s)? "
    player_action = STDIN.gets.chomp
    puts "---------------------------------------------\n"
    
    case player_action
    when 'hit', 'h'
      game.player_request_hit
    when 'stand', 's'
      game.player_request_stand
    else
      puts "\n\n\nAction \"#{player_action}\" not supported. Valid action: hit, h, stand, or s.\n\n\n\n\n"
      next
    end
  end
  
  game.print_game_state
  winner_string = game.game_status.to_s.split('_').join(' ')
  puts "\n\n\n#{winner_string}\n\n"
  
  print "Play again (y/n)? Enter any other key to terminate the game. "
  play_again = STDIN.gets.chomp.downcase == 'y'
end

puts "\nGame terminated. Goodbye.\n"
