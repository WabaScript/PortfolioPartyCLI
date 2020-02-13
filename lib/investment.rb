
class Investment < ActiveRecord::Base

    belongs_to :portfolio

    #Method works fine, but API limits calls to 5 per minute so it will fail on a large table
    
    def self.update_all_prices_to_current
        Investment.all.each do |investment|
            investment.update(current_price: get_current_stock_price(investment.symbol))
        end
    end

    def self.update_all_prices_to_current_slowly
        index = 0
        last_investment = Investment.all.length
        while index <= last_investment do 
             5.times do 
                Investment.all[index].update(current_price: get_current_stock_price(Investment.all[index].symbol))
                index += 1
                if index == last_investment
                    break
                end
            end
        puts "Sleeping for 60 seconds, please wait."
        sleep(60)
        end
    end

    def self.update_all_prices_to_current_slowly_better
        index = 0
        last_investment = Investment.all.length
        
        Investment.all.each do |investment|
            Investment.all[index].update(current_price: get_current_stock_price(Investment.all[index].symbol))
            index += 1
            remaining_iterations = last_investment - index
            puts "Sleeping for 12 seconds, please wait. #{remaining_iterations} iterations until finish."
            sleep(12)
        end
    end


    def delete_investment
        puts "Investment Deleted."
    end

    # def investment_value
    #     self.

end