module Menu
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

  private

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
