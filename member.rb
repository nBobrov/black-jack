class Member
  INITIAL_BANK = 100

  attr_accessor :bank, :score, :cards
  attr_reader :name, :color

  def initialize(*)
    @bank = INITIAL_BANK
    @cards = []
    @score = 0
  end

  def scoring(card)
    @score += card.get_score(@score)
  end

  def add_card(card)
    @cards << card
    scoring(card)
  end

  def bet(value)
    @bank -= value
  end

  def reset
    @cards = []
    @score = 0
  end

  def bankrupt?
    true if @bank.zero?
  end
end
