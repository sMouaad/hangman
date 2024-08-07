require_relative 'lib/game'

begin
  puts 'Press enter to load default dictionnary'
  file_to_load = gets.chomp
  game = (file_to_load.empty? ? Game.new : Game.new(file_to_load))
rescue StandardError
  puts 'File does not exist, try again.'
  retry
end

game.start
