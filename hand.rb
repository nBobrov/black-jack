class Hand
  attr_accessor :cards, :score

  def initialize
    @cards = []
    @score = 0
  end

  def scoring(card)
    @score += card.get_score(@score)
  end
end
