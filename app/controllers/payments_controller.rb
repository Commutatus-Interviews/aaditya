class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @payment = Payment.new
    @friends = User.where.not(id: current_user.id)
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to root_path, notice: "Payment recorded successfully."
    else
      @friends = User.where.not(id: current_user.id)
      render :new
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:payer_id, :payee_id, :amount, :notes)
  end
end
