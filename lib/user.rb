
class User < ActiveRecord::Base
    has_many :portfolios

    def portfolios
        Portfolio.all.select {|portfolio| portfolio.user_id == self.id}
    end
end
