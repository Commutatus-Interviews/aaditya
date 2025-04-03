class ExpenseSplit < ApplicationRecord
  belongs_to :expense
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
