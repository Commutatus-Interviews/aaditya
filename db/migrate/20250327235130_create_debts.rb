class CreateDebts < ActiveRecord::Migration[6.1]
  def change
    create_table :debts do |t|
      t.references :debtor, null: false, foreign_key: { to_table: :users }
      t.references :creditor, null: false, foreign_key: { to_table: :users }
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end
    add_index :debts, [:debtor_id, :creditor_id], unique: true
  end
end