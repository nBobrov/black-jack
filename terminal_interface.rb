class TerminalInterface
  def initialize(game)
    @game = game
    @user = @game.user
    @dealer = @game.dealer

    set_user_name
    @game.start
    welcome_user
  end

  def menu(menu_arr)
    loop do
      menu_item = select_menu_item(menu_arr)

      next unless menu_item
      break if menu_item[:method] == 'exit'

      execute_method(menu_item[:method])
    end
  end

  def select_menu_item(menu_arr)
    puts 'Какое действие хотите выполнить?'
    puts '__________________________________________________________________________'
    menu_arr.each_with_index do |menu_item, index|
      puts "#{index} - #{menu_item[:name]}"
    end
    puts '__________________________________________________________________________'

    menu_arr[gets.chomp.to_i]
  end

  def execute_method(method_name)
    send(method_name)
  end

  def format_text(text, color = nil, bold = nil)
    text = color_text(text, color) unless color.nil?
    text = bold_text(text) unless bold.nil?
    text
  end

  def set_user_name
    puts 'Введите ваше имя:'
    @user.name = gets.chomp.to_s
  rescue ArgumentError => e
    puts format_text(e.message, 'red')
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
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
    puts "Количество очков: #{member.hand.score}" if mode == 1
    puts "Банк: #{member.bank} долларов"
    cards_info(member, mode)
  end

  def cards_info(member, mode = 1)
    puts 'Карты:'
    member.hand.cards.each_with_index do |card, index|
      if mode == 1
        puts "#{index + 1} - #{format_text(card.suit, card.color) + card.value}"
      else
        puts "#{index + 1} - **"
      end
    end
  end

  def add_card
    winner = @game.add_card
    if winner.nil?
      game_info
    else
      end_game(winner)
    end
  rescue ArgumentError => e
    puts format_text(e.message, 'red')
    game_info
  end

  def open_card
    winner = @game.finish
    end_game(winner)
  end

  def end_game(winner)
    game_info(1)
    if winner.nil?
      puts 'Ничья'
    else
      puts "Победитель #{format_text(winner.name, 'green')}"
    end
    menu(END_MENU)
    exit
  end

  def skip_turn
    winner = @game.dealer_move
    if winner.nil?
      game_info
      menu(GAME_MENU)
      exit
    else
      end_game(winner)
    end
  end

  def request_game_replay
    @game.replay
    game_info
    menu(GAME_MENU)
    exit
  rescue ArgumentError => e
    puts format_text(e.message, 'red')
    exit
  end

  private

  GAME_MENU = [{ name: 'Добавить карту', method: 'add_card' },
               { name: 'Открыть карты', method: 'open_card' },
               { name: 'Пропустить', method: 'skip_turn' },
               { name: 'Выйти', method: 'exit' }].freeze
  END_MENU = [{ name: 'Повторить игру', method: 'request_game_replay' },
              { name: 'Выйти', method: 'exit' }].freeze

  def retry_input(counter, limit)
    puts "Повторите попытку! Попыток осталось: #{limit - counter}"
    counter + 1
  end

  def retry_input?(counter, limit)
    counter < limit
  end

  COLOR = { 'black' => 30, 'red' => 31, 'green' => 32, 'yellow' => 33, 'white' => 37, 'blue' => 36 }.freeze

  def color_text(text, name)
    "\x1b[#{COLOR[name]}m#{text}\x1b[0m"
  end

  def bold_text(text)
    "\x1b[1m#{text}\x1b[0m"
  end
end
