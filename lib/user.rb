
class User < ActiveRecord::Base
    has_many :portfolios
    
    ####Returns all portfolios for the user
    def portfolios
        Portfolio.all.select {|portfolio| portfolio.user_id == self.id}
    end

    ####Just for reference
    # def investments
    #     user_investments = []
    #     self.portfolios.each do |portfolio|
    #         user_investments << portfolio.investments
    #     end
    #     user_investments
    # end
    
    ####Returns all investments for the user
    def investments
        self.portfolios.map {|portfolio| portfolio.investments}
    end

    def create_portfolio(p_name, initial_cash)
        Portfolio.create(user_id: self.id, portfolio_name: p_name, initial_cash: initial_cash, current_cash: initial_cash)
    end

    def delete_user
        self.portfolios.each {|port| port.delete_portfolio}
        self.delete
        puts "User deleted."
    end

end
