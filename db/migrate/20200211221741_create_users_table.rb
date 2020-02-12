class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      u.string :username
      u.string :password
      u.string :first_name
      u.string :last_name
      u.string :email
    end
  end
end
