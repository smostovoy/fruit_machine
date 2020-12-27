class GameEngine
  COLORS = %i[black white green yellow]
  ONE_RUN_PRICE = 5

  def initialize(user, bank)
    @user = user
    @bank = bank
  end

  def run
    game = {
      result: Array.new(4) { colorize }
    }
    uniq = game[:result].uniq.count
    if uniq == 1
      game[:message] = 'Congratulations!'
      pay_account(@bank.total)
    elsif uniq == 4
      game[:message] = 'Congratulations!'
      pay_account(@bank.total / 2)
    elsif (1..4).find {|i| game[:result][i-1] == game[:result][i] }.present?
      game[:message] = 'Congratulations!'
      pay_account(ONE_RUN_PRICE * 2)
    else
      game[:message] = 'No luck this time!'
      deduct_account(ONE_RUN_PRICE)
    end
    game
  end

  def default
    {result: COLORS, winner: false}
  end

  def pay_account(amount)
    Bank.transaction do
      @bank.total -= amount
      @user.account += amount
      @user.save!
      @bank.save!
    end
  end

  def deduct_account(amount)
    Bank.transaction do
      @bank.total += amount
      @user.account -= amount
      @user.save!
      @bank.save!
    end
  end


  private

  def colorize
    case rand
    when 0..0.25
      COLORS[0]
    when 0.25..0.5
      COLORS[1]
    when 0.5..0.75
      COLORS[2]
    when 0.75..1
      COLORS[3]
    end
  end

end
