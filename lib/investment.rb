
class Investment < ActiveRecord::Base

    belongs_to :portfolio

    #Method works fine, but API limits calls to 5 per minute so it will fail on a large table
    def self.update_all_prices_to_current
        Investment.all.each do |investment|
            investment.update(current_price: get_current_stock_price(investment.symbol))
        end
    end

    def delete_investment
        puts "Investment Deleted."
    end

end