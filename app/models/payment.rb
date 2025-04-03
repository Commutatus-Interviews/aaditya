class Payment < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  belongs_to :payee, class_name: 'User'

  validates :amount, numericality: { greater_than: 0 }
end
