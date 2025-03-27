class Debt < ApplicationRecord
  belongs_to :debtor, class_name: 'User'
  belongs_to :creditor, class_name: 'User'

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :debtor_id, uniqueness: { scope: :creditor_id }
end