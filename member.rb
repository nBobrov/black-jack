require_relative 'hand'

class Member
  INITIAL_BANK = 100

  attr_accessor :bank
  attr_reader :name, :hand, :color

  def initialize(*)
    @bank = INITIAL_BANK
    @hand = Hand.new
  end

  def add_card(card)
    @hand.cards << card
    @hand.scoring(card)
  end

  def bet(value)
    @bank -= value
  end

  def reset
    @hand.cards = []
    @hand.score = 0
  end

  def bankrupt?
    true if @bank.zero?
  end
end
