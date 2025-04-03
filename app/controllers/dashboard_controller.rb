class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Expenses where user is either the payer or one of the split participants
    expense_ids = ExpenseSplit.where(user_id: current_user.id).pluck(:expense_id)
    @expenses = Expense.where("user_id = ? OR id IN (?)", current_user.id, expense_ids)

    # Calculate totals:
    @total_due_to_you = Expense.where(user_id: current_user.id)
                               .joins(:expense_splits)
                               .where.not(expense_splits: { user_id: current_user.id })
                               .sum("expense_splits.amount")
    @total_you_owe = ExpenseSplit.where(user_id: current_user.id).sum(:amount)
    @balance = @total_due_to_you - @total_you_owe

    # For simplicity, we recalculate friend balances 
    @friends_who_owe_you = ExpenseSplit.where(expense_id: Expense.where(user_id: current_user.id).select(:id))
                                       .group(:user_id)
                                       .sum(:amount)
    @owed_friends = ExpenseSplit.where.not(user_id: current_user.id)
                                .group(:user_id)
                                .sum(:amount)
  end
end
