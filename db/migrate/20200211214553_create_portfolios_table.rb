class CreatePortfoliosTable < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolios do |p|
      p.string :portfolio_name
      p.float :initial_cash
      p.float :current_cash
      p.integer :user_id
    end
  end
end
