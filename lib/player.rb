class Player
  def play
    loop do
      letter = gets.chomp.downcase
      return letter if letter.between?('a', 'z')
    end
  end
end
