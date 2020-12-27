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

    case game[:result].uniq
    when 1
      game[:winner] = :all_Same
      game[:message] = 'Congratulations!'
      pay_account(@bank.total)
    when 4
      game[:winner] = :all_diff
      game[:message] = 'Congratulations!'
      pay_account(@bank.total / 2)
    else
      game[:winner] = :no
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
