require 'rest-client'
require 'pry'
require 'json'
def get_user_input
  puts "Please Enter Ticker Symbol OR enter 1 to exit"
  input = gets.chomp
end 
def get_user_input_two
    puts "Please Enter Ticker Symbol OR enter 1 to exit"
    yyyymmdd = gets.chomp.to_s
end 
def get_all_data(input, yyyymmdd)
  url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{input}&apikey=4NRHKKZWK1U7T0P1"
  response = RestClient.get(url)
  my_response = JSON.parse(response)
  daily_stock_info = my_response["Time Series (Daily)"][yyyymmdd]
  puts daily_stock_info
end 
def run
    input = get_user_input
    yyyymmdd = get_user_input_two
    get_all_data(input, yyyymmdd)
end 
run