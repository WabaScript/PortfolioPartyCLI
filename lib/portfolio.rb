
class Portfolio < ActiveRecord::Base
    has_many :investments
    belongs_to :users
end