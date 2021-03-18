class Member
  INITIAL_BANK = 100

  attr_accessor :bank
  attr_reader :name

  def initialize(*)
    @bank = INITIAL_BANK
  end

  def add_card
    
  end
end
