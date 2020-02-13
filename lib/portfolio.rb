
class Portfolio < ActiveRecord::Base
    has_many :investments
    belongs_to :user

    ####Returns all investments for the portfolio
    def investments 
        Investment.all.select {|investment| investment.portfolio_id == self.id}
    end

    # def view_investments
    #     puts "ID: #{self.id} Name: #{self.portfolio_name}\n"
    #     puts "| Investmend ID | Symbol | Purchase Date | Purchase Price | Current Price | Number of Shares | Portfolio Name |"
    #     self.investments.each do |i|
    #     puts "| #{i.id} | #{i.symbol} | #{i.purchase_date} | #{i.purchase_price} | #{i.current_price} | #{i.num_shares} | #{self.portfolio_name} |"
    #     end
    #     puts "\n"
    # end

    def view_investments
        puts "\n| Portfolio ID: #{self.id} | Name: #{self.portfolio_name} | Current Cash: #{self.current_cash} | Value: #{self.portfolio_value} |"
        puts "| Investmend ID | Symbol | Purchase Date | Purchase Price | Current Price | Number of Shares | Portfolio Name |"
        self.investments.each do |i|
        puts "| #{i.id.to_s.ljust(14)}| #{i.symbol.ljust(6)} | #{i.purchase_date.ljust(13)} | #{i.purchase_price.to_s.ljust(14)} | #{i.current_price.to_s.ljust(13)} | #{i.num_shares.to_s.ljust(16)} | #{self.portfolio_name.ljust(14)} |"
        end
<<<<<<< HEAD
        puts "\n"
    end

    # def portfolio_value
    #     self.investments.
    # end
=======
        nil
    end
>>>>>>> 44dfead65555e8d085761f622b33af5cd01f3687

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
                symbol: symbol, 
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
            if investment.symbol == new_investment.symbol && investment.purchase_date == current_date_to_YYYYMMDD
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
        if Investment.find(investment_id).num_shares < num_shares
            puts "Sorry, you do not have that many shares to sell."
        else
            Investment.find(investment_id).update(num_shares: Investment.find(investment_id).num_shares - num_shares)
            transaction_price = num_shares * Investment.find(investment_id).current_price
            self.update(current_cash: self.current_cash + transaction_price)
            if Investment.find(investment_id).num_shares == 0
                Investment.find(investment_id).delete
            end
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

<<<<<<< HEAD
    #Portfolio Value Method
end
=======
    def portfolio_value
        self.investments.map {|investment| investment.investment_value}.reduce(0) {|sum, value| sum + value} + self.current_cash
    end






end
>>>>>>> 44dfead65555e8d085761f622b33af5cd01f3687
