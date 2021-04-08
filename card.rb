class Card
  SUITS = [{ name: 'Бубны', symbol: "\u2666".encode('utf-8'), color: 'red' },
           { name: 'Червы', symbol: "\u2665".encode('utf-8'), color: 'red' },
           { name: 'Трефы', symbol: "\u2663".encode('utf-8'), color: 'black' },
           { name: 'Пики', symbol: "\u2660".encode('utf-8'), color: 'black' }].freeze

  NUMBER_VALUES = Hash[('2'..'10').to_a.zip((2..10).to_a)].freeze
  FIGURE_VALUES = { 'В' => 10, 'Д' => 10, 'К' => 10, 'Т' => 1 }.freeze
  VALUES = NUMBER_VALUES.merge(FIGURE_VALUES)

  ACE_BIG_VALUE = 11

  attr_reader :suit, :value, :score, :color

  def initialize(suit, value, score, color)
    @suit = suit
    @value = value
    @score = score
    @color = color
  end

  def get_score(value)
    if self.value == 'Т' && (value + ACE_BIG_VALUE) <= 21
      ACE_BIG_VALUE
    else
      score
    end
  end
end
