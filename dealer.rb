class Dealer < Member
  DEALER_NAME = 'Дилер'.freeze

  def initialize
    super
    @name = DEALER_NAME
  end
end
