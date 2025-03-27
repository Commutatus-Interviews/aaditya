# app/models/expense.rb
class Expense < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  has_and_belongs_to_many :participants, class_name: 'User', join_table: :expense_participants
  has_many :debts, dependent: :destroy

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :date, presence: true
  validates :payer, presence: true
  validates :participants, presence: true, length: { minimum: 1 }

  after_create :update_debt_records

  private

  def update_debt_records
    return if participants.empty?

    share = (amount / participants.count).round(2)
    participants.each do |participant|
      next if participant == payer

      debt = Debt.find_or_initialize_by(debtor_id: participant.id, creditor_id: payer.id)
      debt.amount += share
      debt.save!
    end
  end
end
