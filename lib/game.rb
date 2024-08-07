require_relative 'dictionnary'
require_relative 'player'
require_relative 'clear_screen'
require 'yaml'
require 'colorize'
# Game class contains the game logic
class Game
  include ClearScreen

  STICKMAN_HEAD = 'o'.freeze
  STICKMAN_LEFT_ARM = '/'.freeze
  STICKMAN_RIGHT_ARM = '\\'.freeze
  STICKMAN_BODY = '|'.freeze
  STICKMAN_LEFT_LEG = '/'.freeze
  STICKMAN_RIGHT_LEG = '\\'.freeze
  ALPHABETS = ('a'..'z').to_a.freeze
  def initialize(dictionnary_file = 'google-10000-english-no-swears.txt')
    Dictionnary.load_dict(dictionnary_file)
    @player = Player.new
    @word = Dictionnary.random_word.chars
    @letters_played = []
    @mistakes = 0
  end

  def save_game
    File.write('save.yaml', YAML.dump(self))
  end

  def start
    loop do
      print_game
      prompt_save_game unless @letters_played.empty? && @mistakes == 6
      print_game
      if check_win
        puts 'You WON!'
        return
      end
      return if @mistakes == 6

      # Plays again if player chooses already played letter
      letter_played = nil
      loop do
        letter_played = @player.play
        break unless @letters_played.include? letter_played

        puts 'Letter already choosed...'
      end
      @letters_played.push(letter_played)
      check_mistake(letter_played)
    end
  end

  def prompt_save_game
    puts 'Want to save current game? Y for yes'
    case gets.chomp.downcase
    when 'y'
      save_game
    end
  end

  def check_mistake(letter_played)
    return if @word.include? letter_played

    @mistakes += 1
  end

  def check_win
    (@word.uniq & @letters_played).eql?(@word.uniq)
  end

  def print_game
    clear_screen
    print_hang
    print_alphabets
  end

  def print_hang # rubocop:disable Metrics/CyclomaticComplexity
    puts "  ________        #{print_letters}"
    puts ' |        |'
    puts " |        #{@mistakes.positive? ? STICKMAN_HEAD : ''}"
    puts " |       #{@mistakes > 1 ? STICKMAN_LEFT_ARM : ''}#{@mistakes > 2 ? STICKMAN_BODY : ''}#{@mistakes > 3 ? STICKMAN_RIGHT_ARM : ''}" # rubocop:disable Layout/LineLength
    puts " |       #{@mistakes > 4 ? STICKMAN_LEFT_LEG : ''} #{@mistakes == 6 ? STICKMAN_RIGHT_LEG : ''}"
    puts " |   #{@mistakes == 6 ? "You lose... the word was #{@word.join}" : ''}"
    puts '_|_______'
  end

  def print_letters
    @word.map { |letter| @letters_played.include?(letter) ? letter : '_' }.join
  end

  def print_alphabets
    ALPHABETS.each do |letter|
      print("#{if @letters_played.include?(letter)
                 letter.upcase.colorize(color: :grey,
                                        mode: :strike)
               else
                 letter.upcase
               end} ")
    end
    puts
  end
end
