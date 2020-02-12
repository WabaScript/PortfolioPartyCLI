user1 = User.create(first_name: "Joe", last_name: "Block", username: "JoeB", password: "123", email: "JoeeyB@italyrulez.com")
user2 = User.create(first_name: "John", last_name: "Block", username: "JohnB", password: "456", email: "JohnB@yahoo.com")
user3 = User.create(first_name: "Rick", last_name: "Sanchez", username: "RSanchez", password: "789", email: "Rick.Sanchez@rickandmorty.com")
user4 = User.create(first_name: "Morty", last_name: "Smith", username: "Morty", password: "111", email: "Morty@gmail.com")
user5 = User.create(first_name: "Summer", last_name: "Smith", username: "S.Smith", password: "222", email: "Summer@gmail.com.com")

portfolio1 = Portfolio.create(portfolio_name: "Aggressive", initial_cash: 10000, current_cash: 10000, user_id: 1)
portfolio2 = Portfolio.create(portfolio_name: "Conservative", initial_cash: 100000, current_cash: 100000, user_id: 2)
portfolio3 = Portfolio.create(portfolio_name: "High Yield", initial_cash: 20000, current_cash: 20000, user_id: 3)
portfolio4 = Portfolio.create(portfolio_name: "Bond", initial_cash: 10000, current_cash: 10000, user_id: 3)
portfolio5 = Portfolio.create(portfolio_name: "Aggressive", initial_cash: 50000, current_cash: 50000, user_id: 3)
portfolio6 = Portfolio.create(portfolio_name: "Conservative", initial_cash: 40000, current_cash: 40000, user_id: 3)
portfolio7 = Portfolio.create(portfolio_name: "Aggressive", initial_cash: 10000, current_cash: 10000, user_id: 4)
portfolio8 = Portfolio.create(portfolio_name: "Conservative", initial_cash: 125000, current_cash: 125000, user_id: 4)
portfolio9 = Portfolio.create(portfolio_name: "Bond", initial_cash: 25000, current_cash: 25000, user_id: 5)
portfolio10 = Portfolio.create(portfolio_name: "High Yield", initial_cash: 10000, current_cash: 10000, user_id: 5)

investment1 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-01-01",portfolio_id: 1, num_shares: 20)
investment2 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-02-01",portfolio_id: 1, num_shares: 30)
investment3 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-03-01",portfolio_id: 1, num_shares: 25)
investment4 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-01-01",portfolio_id: 2, num_shares: 20)
investment5 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-02-01",portfolio_id: 2, num_shares: 30)
investment6 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-05-01",portfolio_id: 3, num_shares: 25)
investment7 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-06-01",portfolio_id: 4, num_shares: 20)
investment8 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-08-01",portfolio_id: 5, num_shares: 30)
investment9 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 5, num_shares: 25)
investment10 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-02-01",portfolio_id: 6, num_shares: 20)
investment11 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-02-01",portfolio_id: 7, num_shares: 30)
investment12 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 8, num_shares: 25)
investment13 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-01-01",portfolio_id: 9, num_shares: 20)
investment14 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 9, num_shares: 30)
investment15 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 9, num_shares: 25)
investment16 = Investment.create(symbol: "MSFT", purchase_price: 90, current_price: 80, purchase_date: "2020-01-01",portfolio_id: 10, num_shares: 20)
investment17 = Investment.create(symbol: "AAPL", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 10, num_shares: 30)
investment18 = Investment.create(symbol: "G", purchase_price: 85, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 10, num_shares: 25)
investment19 = Investment.create(symbol: "C", purchase_price: 100, current_price: 80, purchase_date: "2020-01-01",portfolio_id: 10, num_shares: 20)
investment20 = Investment.create(symbol: "GE", purchase_price: 100, current_price: 95, purchase_date: "2020-01-01",portfolio_id: 10, num_shares: 30)