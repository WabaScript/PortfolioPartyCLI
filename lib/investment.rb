
class Investment < ActiveRecord::Base

    belongs_to :portfolio
    
    ####Returns true is stock symbol is valid, false if not (probably not needed as an instance method)
    # def symbol_validate (input)
    #     url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{input}&apikey=4NRHKKZWK1U7T0P1"
    #     response = RestClient.get(url)
    #     my_response = JSON.parse(response)
    #     if my_response["Error Message"] == nil
    #         true
    #     else
    #         false
    #     end
    # end

    #Method works fine, but API limits calls to 5 per minute so it will fail on a large table
    def self.update_all_prices_to_current
        Investment.all.each do |investment|
            investment.update(current_price: get_current_stock_price(investment.symbol))
        end
    end



end