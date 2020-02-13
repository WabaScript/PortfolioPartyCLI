require_relative "../config/environment"

$prompt = TTY::Prompt.new
$active_user = nil
$active_portfolio = nil

def main_menu
    puts "Welcome to Portfolio Party v 2.0.3.2"
    menu_options = ["Login", "Create New User", "Quit"]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "Login"
        login
    when "Create New User"
        create_a_new_user
    when "Quit"
        puts "Goodbye"
    end
end

def login
    puts "PLEASE LOGIN\n\n"
    username_input = $prompt.ask("Please enter username:")
    password_input = $prompt.mask("Please enter password:")
    $active_user = User.all.find_by(username: username_input, password: password_input)

    if $active_user == nil
        puts "Sorry, no user found with that matches that combination of username and password."
        puts "Returning to main menu.\n\n\n\n"
        main_menu
    else
        puts "Login successful.  Welcome #{$active_user.full_name}."
        user_logged_in_menu
    end
end

def create_a_new_user
    puts "Username must be unique and cannot be changed after account creation.\n\n"

    username_input = $prompt.ask("Please enter new username:")
    password_input = $prompt.mask("Please enter new password:")
    first_name_input = $prompt.ask("Please enter first name:")
    last_name_input = $prompt.ask("Please enter last name:")
    email_input = $prompt.ask("Please enter email address:") {|q| q.validate :email}
    
    if !User.all.find_by(username: username_input)
    new_user = User.create(
        username: username_input,
        password: password_input,
        first_name: first_name_input,
        last_name: last_name_input,
        email: email_input
    )
        puts "New user successfully created.  Please login."
        new_user.display_information
        login
    else 
        puts "Sorry, username already exists."
        puts "Returning to main menu.\n\n\n\n"
        main_menu
    end
end

def user_logged_in_menu
    puts "Your existing portfolios are:\n\n"
    $active_user.portfolios.each {|portfolio| puts "| ID: #{portfolio.id} | Name: #{portfolio.portfolio_name}"}
    puts "\n"
    menu_options = ["View All Investments", "View Portfolio (BUY / SELL / RESEARCH)", "Create New Portfolio", "Delete Portfolio", "Modify / Display User Info", "Return to Main Menu" ]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "View All Investments"
        if $active_user.investments.length >= 1
        $active_user.view_all_investments
        else
            puts "You have no investments."
        end
        user_logged_in_menu
    when "View Portfolio (BUY / SELL / RESEARCH)"
        portfolio_selection = $prompt.ask("Please enter portfolio ID:", required: true)
        if Portfolio.exists?(portfolio_selection)
        $active_portfolio = Portfolio.find(portfolio_selection)
            if $active_user.id == $active_portfolio.user_id
                puts "#{$active_portfolio.portfolio_name} contains:"
                $active_portfolio.view_investments
            portfolio_menu
            else
                puts "This portfolio ID does not belong to you"
                user_logged_in_menu
            end
        else
            puts "No Portfolio with that ID found"
            user_logged_in_menu
        end
    when "Create New Portfolio"
        puts "Portfolio name must be unique."
        new_port_name_input = $prompt.ask("Please enter new portfolio name:")
        new_init_cash_input = $prompt.ask("Please enter an initial portfolio cash value:")

        if !Portfolio.all.find_by(portfolio_name: new_port_name_input)
            new_portfolio = Portfolio.create(
                portfolio_name: new_port_name_input,
                initial_cash: new_init_cash_input,
                current_cash: new_init_cash_input,
                user_id: $active_user.id
            )
                puts "New portfolio successfully created."
                user_logged_in_menu
            else 
                puts "Sorry, portfolio name already exists.  Please enter a unique portfolio name."
                puts "Returning to portfolio menu"
                user_logged_in_menu
            end

    when "Delete Portfolio"
        portfolio_selection = $prompt.ask("Please enter portfolio ID:")
        $active_portfolio = Portfolio.find(portfolio_selection)
        yes_no = $prompt.yes?("Are you sure?  This will permanently delete the porfolio and all associated investment data.")
            if yes_no == true
                $active_portfolio.delete_portfolio
                $active_portfolio = nil
                puts "Returning to Portfolio Menu\n"
                user_logged_in_menu
            else
                puts "Delete aborted.\n"
                puts "Returning to Portfolio Menu\n"
                user_logged_in_menu
            end
    when "Modify / Display User Info"
        modify_user
    when "Return to Main Menu"
        $active_user = nil
        main_menu
    end
end

def portfolio_menu

    menu_options = ["Buy Stock", "Sell Stock", "Research Stock", "Return to Portfolio Menu"]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "Buy Stock"
        symbol_input = $prompt.ask("Please enter stock ticker symbol:")
        num_shares_input = $prompt.ask("Please enter number of shares to buy:")
        $active_portfolio.buy_stock(symbol_input, num_shares_input.to_f)
        $active_portfolio.view_investments
        portfolio_menu
    when "Sell Stock"
        invest_id_input = $prompt.ask("Please enter investment ID:")
        num_shares_input = $prompt.ask("Please enter number of shares to sell:")
        if $active_portfolio.id == Investment.find(invest_id_input).portfolio_id 
            $active_portfolio.sell_stock_by_investment_id(invest_id_input.to_i, num_shares_input.to_i)
            $active_portfolio.view_investments
            portfolio_menu
        else
            puts "Investment ID error"
            portfolio_menu
        end
    when "Research Stock"
        symbol_input = $prompt.ask("Please enter stock ticker symbol:")
        get_current_stock_data(symbol_input)
        portfolio_menu
    when "Return to Portfolio Menu"
        $active_portfolio = nil
        user_logged_in_menu
    end
end

def modify_user
    puts "Current user details:\n"
    $active_user.display_information
    
    puts "\nModify User Info.  Username cannot be changed.\n\n"
    menu_options = ["Password", "First Name", "Last Name", "Email", "Delete User", "Return to Portfolio Menu"]
    input = $prompt.select("Which attribute would you like to edit:", menu_options)
    
    case input
    when "Password"
    password_input = $prompt.mask("Please enter new password:")
    $active_user.update(password: password_input)
    puts "Password successfully updated."
    puts "Returning to Portfolio Menu.\n"
    user_logged_in_menu
    when "First Name"
    first_name_input = $prompt.ask("Please enter first name:")
    $active_user.update(first_name: first_name_input)
    puts "First name successfully updated."
    puts "Returning to Portfolio Menu.\n"
    user_logged_in_menu
    when "Last Name"
    last_name_input = $prompt.ask("Please enter last name:")
    $active_user.update(last_name: last_name_input)
    puts "Last name successfully updated."
    puts "Returning to Portfolio Menu.\n"
    user_logged_in_menu
    when "Email"
    email_input = $prompt.ask("Please enter email address:") {|q| q.validate :email}
    $active_user.update(email: email_input)
    puts "Email successfully updated."
    puts "Returning to Portfolio Menu.\n"
    user_logged_in_menu
    when "Delete User"
        yes_no = $prompt.yes?("Are you sure?  This will permanently delete the user, all associated portfolios and investments.")
        if yes_no == true
            $active_user.delete_user
            $active_user = nil
            puts "User deleted.\n"
            puts "Returning to Main Menu.\n"
            main_menu
        else
            puts "Delete aborted.\n"
            puts "Returning to Modify User Menu.\n"
            modify_user
        end
    when "Return to Portfolio Menu"
        puts "Returning to Portfolio Menu.\n"
        user_logged_in_menu
    end
end
