class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :payer, null: false, foreign_key: { to_table: :users }
      t.text :description
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.timestamps
    end
  end
end

