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
      # For equal splits, use the selected user IDs (from split_with_users checkboxes)
      @expense.split_equal(params[:split_with_users])
    elsif params[:split_type] == "unequal"
      # For unequal splits, we expect params[:splits] to be provided as a hash (user_id => amount)
      if params[:splits].present?
        splits = params[:splits].transform_values(&:to_d)
        # Validate that the sum equals the total_amount inside the split_unequal method.
        return render :new unless @expense.split_unequal(splits)
      else
        flash.now[:alert] = "Please provide split amounts for unequal split."
        @users = User.where.not(id: current_user.id)
        return render :new
      end
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
    # Exclude :user_id because it's automatically assigned as current_user.
    params.require(:expense).permit(:date, :description, :total_amount)
  end
end
