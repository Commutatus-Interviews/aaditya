class ExpensesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @expense = Expense.new
    @users = User.where.not(id: current_user.id)
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user  # Automatically assign the current user as the payer

    if params[:split_type] == "equal"
      # Use the checkboxes value from "split_with_users[]"
      @expense.split_equal(params[:split_with_users])
    elsif params[:split_type] == "unequal"
      # For unequal splits you would need a separate input field to enter amounts per user.
      # This example assumes you're passing a hash of user_id => amount in params[:splits].
      splits = params[:splits].transform_values(&:to_d)
      return render :new unless @expense.split_unequal(splits)
    end

    if @expense.save
      redirect_to root_path, notice: "Expense created successfully."
    else
      @users = User.where.not(id: current_user.id)
      render :new
    end
  end

  private

  def expense_params
    # Exclude :user_id because it's automatically assigned
    params.require(:expense).permit(:date, :description, :total_amount)
  end
end
