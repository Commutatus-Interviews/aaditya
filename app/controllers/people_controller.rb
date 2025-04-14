class PeopleController < ApplicationController
  before_action :authenticate_user!

  def show
    @friend = User.find(params[:id])
    # Retrieve all expenses that involve the friend (either as payer or participant)
    expense_ids = ExpenseSplit.where(user_id: @friend.id).pluck(:expense_id)
    @expenses = Expense.where("user_id = ? OR id IN (?)", @friend.id, expense_ids)
  end
end
