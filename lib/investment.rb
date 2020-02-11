
class Investment < ActiveRecord::Base

    attr_accessor :symbol, :purchase_price, :purchase_date, :current_price :portfolio, :num_shares
    belongs_to :portfolio

    def initialize
    end

    def symbol_validate
        if 


end