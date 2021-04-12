require_relative 'member'
require_relative 'user'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'game'
require_relative 'terminal_interface'

class BlackJack
  def initialize
    user = User.new
    dealer = Dealer.new
    game = Game.new(user, dealer)

    TerminalInterface.new(game)
  end
end

BlackJack.new
