class SettlementsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @other_user = User.find(params[:other_user_id])
    amount = params[:amount].to_f

    debt = Debt.find_by(debtor_id: current_user.id, creditor_id: @other_user.id)
    if debt
      if debt.amount >= amount
        debt.amount -= amount
        debt.save!
      else
        remaining = amount - debt.amount
        debt.destroy!
        Debt.create!(debtor_id: @other_user.id, creditor_id: current_user.id, amount: remaining)
      end
    else
      Debt.create!(debtor_id: @other_user.id, creditor_id: current_user.id, amount: amount)
    end

    redirect_to dashboard_path, notice: 'Payment processed successfully'
  end
end