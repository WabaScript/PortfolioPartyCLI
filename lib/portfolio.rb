
class Portfolio < ActiveRecord::Base
    has_many :investments
    belongs_to :user

    ####Returns all investments for the portfolio
    def investments 
        Investment.all.select {|investment| investment.portfolio_id == self.id}
    end

    # def view_investments
    #     puts "\n| Portfolio ID: #{self.id} | Name: #{self.portfolio_name} | Initial Cash: $#{self.initial_cash.round(0)} | Current Cash: $#{self.current_cash.round(0)} | Value: $#{self.portfolio_value.round(0)} | P&L: #{self.portfolio_pl.round(1)} | P&L %: #{self.portfolio_pl_ratio.round(1)} |".bold
    #     puts "| Investmend ID | Symbol | Purchase Date | Purchase Price | Current Price | Number of Shares |   Value   |    P&L    | P&L % |"
    #     self.investments.each do |i|
    #     puts "| #{i.id.to_s.ljust(14)}| #{i.symbol.ljust(6)} | #{i.purchase_date.ljust(13)} | #{i.purchase_price.to_s.ljust(14)} | #{i.current_price.to_s.ljust(13)} | #{i.num_shares.to_s.ljust(16)} | #{i.investment_value.round(1).to_s.ljust(9)} | #{i.investment_pl.round(1).to_s.ljust(9)} | #{i.investment_pl_ratio.round(1).to_s.ljust(5)} |"
    #     end
    #     nil
    # end

    def view_investments
        if self.portfolio_pl > 0
            puts "\n| Portfolio ID: #{self.id} | Name: #{self.portfolio_name} | Initial Cash: $#{self.initial_cash.round(0)} | Current Cash: $#{self.current_cash.round(0)} | Value: $#{self.portfolio_value.round(0)} | P&L: #{self.portfolio_pl.round(1).to_s.green} | P&L %: #{self.portfolio_pl_ratio.round(1).to_s.green} |".bold
        elsif self.portfolio_pl < 0
            puts "\n| Portfolio ID: #{self.id} | Name: #{self.portfolio_name} | Initial Cash: $#{self.initial_cash.round(0)} | Current Cash: $#{self.current_cash.round(0)} | Value: $#{self.portfolio_value.round(0)} | P&L: #{self.portfolio_pl.round(1).to_s.red} | P&L %: #{self.portfolio_pl_ratio.round(1).to_s.red} |".bold
        else 
            puts "\n| Portfolio ID: #{self.id} | Name: #{self.portfolio_name} | Initial Cash: $#{self.initial_cash.round(0)} | Current Cash: $#{self.current_cash.round(0)} | Value: $#{self.portfolio_value.round(0)} | P&L: #{self.portfolio_pl.round(1)} | P&L %: #{self.portfolio_pl_ratio.round(1)} |".bold
        end
        puts "| Investmend ID | Symbol | Purchase Date | Purchase Price | Current Price | Number of Shares |   Value   |    P&L    | P&L % |"
        self.investments.each do |i|
            if i.investment_pl > 0
                puts "| #{i.id.to_s.ljust(14)}| #{i.symbol.ljust(6)} | #{i.purchase_date.ljust(13)} | #{i.purchase_price.to_s.ljust(14)} | #{i.current_price.to_s.ljust(13)} | #{i.num_shares.to_s.ljust(16)} | #{i.investment_value.round(1).to_s.ljust(9)} | #{i.investment_pl.round(1).to_s.ljust(9).green} | #{i.investment_pl_ratio.round(1).to_s.ljust(5).green} |"
            elsif i.investment_pl < 0
                puts "| #{i.id.to_s.ljust(14)}| #{i.symbol.ljust(6)} | #{i.purchase_date.ljust(13)} | #{i.purchase_price.to_s.ljust(14)} | #{i.current_price.to_s.ljust(13)} | #{i.num_shares.to_s.ljust(16)} | #{i.investment_value.round(1).to_s.ljust(9)} | #{i.investment_pl.round(1).to_s.ljust(9).red} | #{i.investment_pl_ratio.round(1).to_s.ljust(5).red} |"
            else
                puts "| #{i.id.to_s.ljust(14)}| #{i.symbol.ljust(6)} | #{i.purchase_date.ljust(13)} | #{i.purchase_price.to_s.ljust(14)} | #{i.current_price.to_s.ljust(13)} | #{i.num_shares.to_s.ljust(16)} | #{i.investment_value.round(1).to_s.ljust(9)} | #{i.investment_pl.round(1).to_s.ljust(9)} | #{i.investment_pl_ratio.round(1).to_s.ljust(5)} |"
            end
        end
        nil
    end

    def validate_buy (symbol, num_shares)
        current_price = get_current_stock_price(symbol)
        if !current_price
            puts "I'm sorry, that stock ticker symbol is not valid."
            puts "No investment created."
            false
        elsif self.current_cash <= current_price * num_shares
            puts "I'm sorry, there is not enough cash in the portfolio fill that order."
            puts "No investment created."
            false
        else
            true
        end
    end
 
    ####Returns new investment in the portfolio and debits current cash if the transaction is valid, otherwise returns nil.  Introduces local current_price variable to reduce API calls.
    def buy_stock (symbol, num_shares)
        if validate_buy(symbol, num_shares)
            current_price = get_current_stock_price(symbol)
            transaction_price = current_price * num_shares
            self.update(current_cash: self.current_cash - transaction_price)
            new_investment = Investment.new(
                symbol: symbol.upcase, 
                purchase_price: current_price, 
                current_price: current_price, 
                purchase_date: current_date_to_YYYYMMDD, 
                portfolio_id: self.id, 
                num_shares: num_shares
                )
            if aggregate_investments_same_stock_and_date(new_investment) == nil
                new_investment.save
            end
        end
    end


    ####Called when a new stock is purchases, doesn't allow for multiple instances of an investment with the same purchase date (and hence price) and symbol to help deal with display of the portfolio and selling
    def aggregate_investments_same_stock_and_date (new_investment)
        conbined_investment = nil
        self.investments.each do |investment|
            if investment.symbol.upcase == new_investment.symbol.upcase && investment.purchase_date == current_date_to_YYYYMMDD
                conbined_investment = Investment.create(
                    symbol: new_investment.symbol, 
                    purchase_price: new_investment.current_price, 
                    current_price: new_investment.current_price, 
                    purchase_date: current_date_to_YYYYMMDD, 
                    portfolio_id: new_investment.portfolio_id, 
                    num_shares: new_investment.num_shares + investment.num_shares
                    )
                investment.delete
            end
        end
        conbined_investment
    end

    def sell_stock_by_investment_id (investment_id, num_shares)
        if Investment.exists?(investment_id)
            if Investment.find(investment_id).num_shares < num_shares
                puts "Sorry, you do not have that many shares to sell."
            else
                Investment.find(investment_id).update(num_shares: Investment.find(investment_id).num_shares - num_shares)
                transaction_price = num_shares * Investment.find(investment_id).current_price
                self.update(current_cash: self.current_cash + transaction_price)
                if Investment.find(investment_id).num_shares == 0
                    Investment.find(investment_id).delete
                end
                puts "Sale successful."
            end
        else
            puts "Investment ID is not valid! Please try again."
        end
    end

    def update_portfolio_to_current_prices
        self.investments.each do |investment|
            investment.update(current_price: get_current_stock_price(investment.symbol))
        end
    end

    def delete_portfolio
        self.investments.each {|investment| investment.delete_investment}
        self.delete
        puts "Portfolio Deleted."
    end

    def portfolio_value
        self.investments.map {|investment| investment.investment_value}.reduce(0) {|sum, value| sum + value} + self.current_cash
    end


    def initial_portfolio_value
        self.investments.map {|investment| investment.initial_inv_value}.reduce(0) {|sum, value| sum + value} + self.current_cash
    end

    def portfolio_pl
        self.portfolio_value - self.initial_portfolio_value
    end

    def portfolio_pl_ratio
        (self.portfolio_value - self.initial_portfolio_value)/self.initial_portfolio_value * 100
    end

end
