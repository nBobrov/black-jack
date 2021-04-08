require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value, score|
        @cards << Card.new(suit[:symbol], value, score, suit[:color])
      end
    end
  end
end
