class GamesController < ApplicationController
  def create
    @user = User.first
    @bank = Bank.first
    @game = GameEngine.new(@user, @bank).run
    render action: :index
  end

  def index
    @user = User.first
    @bank = Bank.first
    @game = GameEngine.new(@user, @bank).default
  end
end
