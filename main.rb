require_relative 'member'
require_relative 'user'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative 'menu'

class Main
  include Menu

  GAME_MENU = [{ name: 'Добавить карту', method: 'add_card', class: 'Game' },
               { name: 'Открыть карты', method: 'open_card' },
               { name: 'Пропустить', method: 'skip_turn' },
               { name: 'Выйти', method: 'exit' }].freeze
  END_MENU = [{ name: 'Повторить игру', method: 'request_game_replay' },
              { name: 'Выйти', method: 'exit' }].freeze

  DEFAULT_BET = 10
  VICTORY_SCORE = 21

  attr_reader :winner

  def initialize
    @dealer = Dealer.new
    set_user
    start_game
    welcome_user
  end

  def set_user
    puts 'Введите ваше имя:'
    @user = User.new(gets.chomp.to_s)
  rescue ArgumentError => e
    puts format_text(e.message, 'red')
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
  end

  def start_game
    @deck = Deck.new
    @winner = nil
    @bank = 0

    bet(@user)
    bet(@dealer)

    deal_cards_to_member(@user, 2)
    deal_cards_to_member(@dealer, 2)
  end

  def welcome_user
    system 'clear'
    puts "Привет, #{format_text(@user.name, @user.color, 'bold')}! Игра началась."
    puts '__________________________________________________________________________'
    game_info
    menu(GAME_MENU)
  end

  def game_info(mode = 0)
    member_info(@user)
    puts ''
    puts "Банк игры: #{@bank}"
    puts ''
    member_info(@dealer, mode)
  end

  def member_info(member, mode = 1)
    puts "Участник игры: #{format_text(member.name, member.color, 'bold')}"
    puts "Количество очков: #{member.score}" if mode == 1
    puts "Банк: #{member.bank} долларов"
    cards_info(member, mode)
  end

  def cards_info(member, mode = 1)
    puts 'Карты:'
    member.cards.each_with_index do |card, index|
      if mode == 1
        puts "#{index + 1} - #{format_text(card.suit, card.color) + card.value}"
      else
        puts "#{index + 1} - **"
      end
    end
  end

  def add_card
    deal_cards_to_member(@user)
    if check_open_card
      open_card
    else
      dealer_move
      game_info
    end
  end

  def open_card
    game_info(1)
    game_finish
    if winner.nil?
      puts 'Ничья'
    else
      puts "Победитель #{format_text(winner.name, 'green')}"
    end
    menu(END_MENU)
    exit
  end

  def skip_turn
    game_info
    dealer_move
  end

  def request_game_replay
    return unless check_member_bank.nil?

    @dealer.reset
    @user.reset
    start_game
    game_info
    menu(GAME_MENU)
    exit
  end

  def game_finish
    @winner = nominate_winner
    transfer_bank(@winner)
  end

  def transfer_bank(winner)
    if winner.nil?
      @user += DEFAULT_BET
      @dealer.bank += DEFAULT_BET
    else
      winner.bank += @bank
    end
    @bank = 0
  end

  def bet(member)
    member.bet(DEFAULT_BET)
    @bank += DEFAULT_BET
  end

  def nominate_winner
    if @user.score > VICTORY_SCORE || (VICTORY_SCORE - @user.score) > (VICTORY_SCORE - @dealer.score).abs
      @dealer
    elsif (VICTORY_SCORE - @user.score) < (VICTORY_SCORE - @dealer.score).abs
      @user
    end
  end

  def dealer_move
    return unless (@dealer.score <= 17) && (@dealer.cards.length < 3)

    deal_cards_to_member(@dealer)
    if check_open_card
      open_card
    else
      menu(GAME_MENU)
      exit
    end
  end

  def check_open_card
    return unless @user.cards.length == 3 && @dealer.cards.length == 3

    true
  end

  def check_member_bank
    bankrupt = @dealer if @dealer.bankrupt?
    bankrupt = @user if @user.bankrupt?
    puts format_text("У участника #{bankrupt.name} в банке нет средств для ставки!", 'red') unless bankrupt.nil?
    bankrupt
  end

  def deal_cards_to_member(member, card_count = 1)
    if member.cards.length > 2
      puts format_text('У вас максимальное количество карт', 'red')
      return
    end

    i = 0
    while (i += 1) <= card_count
      card = @deck.cards.delete_at(rand(@deck.cards.length))
      member.add_card(card)
    end
  end
end

Main.new
