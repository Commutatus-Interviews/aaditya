class Expense < ApplicationRecord
  belongs_to :user  # Person who paid
  has_many :expense_splits, dependent: :destroy
  accepts_nested_attributes_for :expense_splits

  validates :total_amount, numericality: { greater_than: 0 }
  validates :date, :description, presence: true

  # Equal split method
  def split_equal(user_ids)
    count = user_ids.count
    share = (total_amount / count).round(2)
    remainder = total_amount - (share * count)
    
    user_ids.each_with_index do |uid, index|
      amount = share
      amount += remainder if index == 0  
      expense_splits.build(user_id: uid, amount: amount)
    end
  end

  def split_unequal(splits_hash)
    if splits_hash.values.sum.to_d != total_amount.to_d
      errors.add(:base, "Split amounts must equal total amount")
      return false
    end

    splits_hash.each do |uid, amount|
      expense_splits.build(user_id: uid, amount: amount)
    end
    true
  end
end
