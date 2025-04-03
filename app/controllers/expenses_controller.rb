class ExpensesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @expense = Expense.new
    @users = User.all  # List all users for selection
  end

  def create
    @expense = Expense.new(expense_params)
    
    if params[:split_type] == "equal"
     
      @expense.split_equal(params[:user_ids])
    elsif params[:split_type] == "unequal"
      
      splits = params[:splits].transform_values(&:to_d)
      return render :new unless @expense.split_unequal(splits)
    end

    if @expense.save
      redirect_to root_path, notice: "Expense created successfully."
    else
      @users = User.all
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:date, :description, :total_amount, :user_id)
  end
end
