class Dictionnary
  attr_reader :words

  def initialize(dictionnary_file)
    raise ArgumentError unless File.exist? dictionnary_file

    @words = File.readlines(dictionnary_file).select { |word| word.size.between?(5, 12) }
  end

  def random_word
    words.sample.chomp
  end
end
