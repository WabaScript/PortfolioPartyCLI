
class User < ActiveRecord::Base
    has_many :portfolios
    has_many :investments, through: :portfolios
    
    def full_name
        "#{first_name} #{last_name}"
    end

    def display_information
        puts "Username: #{self.username}"
        puts "Password: #{self.password}"
        puts "First Name: #{self.first_name}"
        puts "Last Name: #{self.last_name}"
        puts "Email: #{self.email}"
    end

    ####Returns all portfolios for the user
    def portfolios
        Portfolio.all.select {|portfolio| portfolio.user_id == self.id}
    end
    
    ####Returns all investments for the user
    
    def investments
        self.portfolios.map {|portfolio| portfolio.investments}
    end

    def view_all_investments
        self.portfolios.each do |portfolio|
            portfolio.view_investments
        end
        nil
    end

    def create_portfolio(p_name, initial_cash)
        Portfolio.create(user_id: self.id, portfolio_name: p_name, initial_cash: initial_cash, current_cash: initial_cash)
    end

    def delete_user
        self.portfolios.each {|port| port.delete_portfolio}
        self.delete
        puts "User Deleted."
    end

end
