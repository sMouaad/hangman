class Dictionnary
  @words = nil
  def self.load_dict(dictionnary_file = 'google-10000-english-no-swears.txt')
    @words = File.readlines(dictionnary_file).select { |word| word.size.between?(5, 12) }
  end

  def self.random_word
    @words.sample.chomp
  end
end
