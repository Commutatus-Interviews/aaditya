class PeopleController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @expenses = Expense.where(payer_id: @user.id)
  end
end