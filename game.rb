class Game
  DEFAULT_BET = 10
  VICTORY_SCORE = 21

  attr_reader :winner, :user, :dealer

  def initialize(user, dealer)
    @user = user
    @dealer = dealer
  end

  def start
    @deck = Deck.new
    @winner = nil
    @bank = 0

    bet(@user)
    bet(@dealer)

    deal_cards_to_member(@user, 2)
    deal_cards_to_member(@dealer, 2)
  end

  def add_card
    deal_cards_to_member(@user)
    if check_open_card
      finish
    else
      dealer_move
    end
  end

  def replay
    validate_bank!(@dealer)
    validate_bank!(@user)

    @dealer.reset
    @user.reset
    start
  end

  def finish
    @winner = nominate_winner
    transfer_bank(@winner)
    @winner
  end

  def transfer_bank(winner)
    if winner.nil?
      @user.bank += DEFAULT_BET
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
    @dealer_score = @dealer.hand.score
    @user_score = @user.hand.score

    if @user_score > VICTORY_SCORE || (VICTORY_SCORE - @user_score) > (VICTORY_SCORE - @dealer_score).abs
      @dealer
    elsif (VICTORY_SCORE - @user_score) < (VICTORY_SCORE - @dealer_score).abs
      @user
    end
  end

  def dealer_move
    return unless (@dealer.hand.score <= 17) && (@dealer.hand.cards.length < 3)

    deal_cards_to_member(@dealer)
    finish if check_open_card
  end

  def check_open_card
    return unless @user.hand.cards.length == 3 && @dealer.hand.cards.length == 3

    true
  end

  def deal_cards_to_member(member, card_count = 1)
    validate_add_card!(member)

    i = 0
    while (i += 1) <= card_count
      card = @deck.cards.delete_at(rand(@deck.cards.length))
      member.add_card(card)
    end
  end

  private

  def validate_add_card!(member)
    raise ArgumentError, 'У вас максимальное количество карт' if member.hand.cards.length > 2
  end

  def validate_bank!(member)
    raise ArgumentError, "У участника #{member.name} в банке нет средств для ставки!" if member.bankrupt?
  end
end
