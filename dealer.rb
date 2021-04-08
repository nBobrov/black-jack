class Dealer < Member
  DEALER_NAME = 'Крупье'.freeze
  DEALER_COLOR = 'yellow'.freeze

  def initialize
    super
    @name = DEALER_NAME
    @color = DEALER_COLOR
  end
end
