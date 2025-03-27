class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.payer = current_user # Default to current user, can be changed via form
    if @expense.save
      redirect_to dashboard_path, notice: 'Expense added successfully'
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:payer_id, :amount, :description, :date, participant_ids: [])
  end
end