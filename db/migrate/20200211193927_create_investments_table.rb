class CreateInvestmentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :investments do |t|
      t.string :symbol
      t.float :purchase_price
      t.float :current_price
      t.string :purchase_date
      t.integer :portfolio_id
      t.integer :num_shares
    end
  end
end
