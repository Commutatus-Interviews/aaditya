class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses_as_payer, class_name: 'Expense', foreign_key: 'payer_id'
  has_and_belongs_to_many :expense_participations, class_name: 'Expense', join_table: :expense_participants
  has_many :debts_as_debtor, class_name: 'Debt', foreign_key: 'debtor_id'
  has_many :debts_as_creditor, class_name: 'Debt', foreign_key: 'creditor_id'

  def total_due_to_you
    debts_as_creditor.sum(:amount)
  end

  def total_you_owe
    debts_as_debtor.sum(:amount)
  end

  def total_balance
    total_due_to_you - total_you_owe
  end

  def friends_you_owe
    debts_as_debtor.group(:creditor_id).sum(:amount).map do |creditor_id, amount|
      [User.find(creditor_id), amount]
    end
  end

  def friends_who_owe_you
    debts_as_creditor.group(:debtor_id).sum(:amount).map do |debtor_id, amount|
      [User.find(debtor_id), amount]
    end
  end
end