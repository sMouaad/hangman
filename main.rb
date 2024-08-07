require_relative 'lib/game'

begin
  puts 'Press enter to load default dictionnary'
  file_to_load = gets.chomp
  game = (file_to_load.empty? ? Game.new : Game.new(file_to_load))
  if p File.exist?('save.yaml')
    puts 'There is a saved game, wanna load it? y/n'
    loop do
      case gets.chomp.downcase
      when 'y'
        game = YAML.safe_load(File.open('save.yaml', 'r'), permitted_classes: [Game, Player])
        break
      when 'n'
        break
      else
        puts 'Y or N'
      end
    end
  end
rescue Errno::ENOENT => e
  puts "File does not exist, #{e.message}"
  retry
end

game.start
