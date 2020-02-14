require_relative "../config/environment"

$prompt = TTY::Prompt.new
$active_user = nil
$active_portfolio = nil

def main_title
    puts "
    ********************************************************************************************************

       $$$$$$\\   $$$$$$\\   $$$$$$\\  $$\\   $$\\       $$\\      $$\\  $$$$$$\\  $$\\   $$\\ $$$$$$$$\\ $$\\     $$\\ 
      $$  __$$\\ $$  __$$\\ $$  __$$\\ $$ |  $$ |      $$$\\    $$$ |$$  __$$\\ $$$\\  $$ |$$  _____|\\$$\\   $$ |
      $$ /  \\__|$$ /  $$ |$$ /  \\__|$$ |  $$ |      $$$$\\  $$$$ |$$ /  $$ |$$$$\\ $$ |$$ |       \\$$\ $$   / 
      $$ |      $$$$$$$$ |\$$$$$$\\   $$$$$$$$ |      $$\\$$\\$$ $$ |$$ |  $$ |$$ $$\\$$ |$$$$$\\      \\$$$$  /  
      $$ |      $$  __$$ | \____$$\\  $$  __$$ |      $$ \\$$$  $$ |$$ |  $$ |$$ \\$$$$ |$$  __|      \\$$  /   
      $$ |  $$\\ $$ |  $$ |$$\   $$ | $$ |  $$ |      $$ |\\$  /$$ |$$ |  $$ |$$ |\\$$$ |$$ |          $$ |    
      \\$$$$$$  |$$ |  $$ |\$$$$$$  | $$ |  $$ |      $$ | \\_/ $$ | $$$$$$  |$$ | \\$$ |$$$$$$$$\\     $$ |    
       \\______/ \\__|  \\__| \\______/ \\__|  \\__|      \\__|     \\__| \\______/ \\__|  \\__|\\________|    \\__| 

    ********************************************************************************************************
     
     ".green.bold
end

def main_menu
    puts "\n\n|---------MAIN MENU---------|\n\n".light_yellow.bold
    puts "Welcome to Portfolio Party v 2.0.3.2\n".blue.bold
    menu_options = ["Login", "Create New User", "Quit"]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "Login"
        login
    when "Create New User"
        create_a_new_user
    when "Quit"
        puts "\n\nGoodbye\n\n".italic
    end
end

def login
    puts "\n\n|---------PLEASE LOGIN---------|\n\n".light_yellow.bold
    username_input = $prompt.ask("Please enter username:")
    password_input = $prompt.mask("Please enter password:")
    $active_user = User.all.find_by(username: username_input, password: password_input)

    if $active_user == nil
        system("clear")
        puts "\n\nSorry, no user found with that matches that combination of username and password."
        puts "Returning to main menu.\n\n"
        main_menu
    else
        system("clear")
        puts "\n\nLogin successful.  Welcome #{$active_user.full_name}."
        user_logged_in_menu
    end
end

def create_a_new_user
    puts "\n\n|---------CREATE NEW USER---------|\n\n".light_yellow.bold
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
        puts "\n\nNew user successfully created.  Please login.\n\n"
        system("clear")
        new_user.display_information
        puts "\n\n"
        login
    else 
        system("clear")
        puts "Sorry, username already exists.\n\n"
        puts "Returning to main menu.\n\n"
        main_menu
    end
end

def user_logged_in_menu
    puts "\n\n|---------USER MENU---------|\n\n".light_yellow.bold
    puts "Your existing portfolios are:\n\n"
    $active_user.portfolios.each {|portfolio| puts "| ID: #{portfolio.id} | Name: #{portfolio.portfolio_name}"}
    puts "\n\n"
    menu_options = ["View All Investments", "View Portfolio (BUY / SELL / RESEARCH)", "Create New Portfolio", "Delete Portfolio", "Modify / Display User Info", "Return to Main Menu" ]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "View All Investments"
        if $active_user.investments.length >= 1
            system("clear")
            puts "Your investments are:\n\n"
        $active_user.view_all_investments
        else
            system("clear")
            puts "\n\nYou have no existing investments.  Create a portfolio to start investing.\n\n"
        end
        user_logged_in_menu
    when "View Portfolio (BUY / SELL / RESEARCH)"
        portfolio_selection = $prompt.ask("Please enter portfolio ID:", required: true)
        if Portfolio.exists?(portfolio_selection)
        $active_portfolio = Portfolio.find(portfolio_selection)
            if $active_user.id == $active_portfolio.user_id
            portfolio_menu
            else
                system("clear")
                puts "This portfolio ID does not belong to you.\n\n"
                user_logged_in_menu
            end
        else
            system("clear")
            puts "No Portfolio with that ID found.\n\n"
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
                system("clear")
                puts "New portfolio successfully created.\n\n"
                user_logged_in_menu
            else 
                system("clear")
                puts "Sorry, portfolio name already exists.  Please enter a unique portfolio name.\n\n"
                puts "Returning to User Menu."
                user_logged_in_menu
            end

    when "Delete Portfolio"
        portfolio_selection = $prompt.ask("Please enter portfolio ID:")
        if Portfolio.exists?(portfolio_selection)
            $active_portfolio = Portfolio.find(portfolio_selection)
            yes_no = $prompt.yes?("Are you sure?  This will permanently delete the porfolio and all associated investment data.")
                if $active_portfolio.user_id == $active_user.id
                    if yes_no == true
                        $active_portfolio.delete_portfolio
                        $active_portfolio = nil
                        puts "\n\nReturning to User Menu\n\n"
                        user_logged_in_menu
                    else
                    system("clear")
                    puts "Delete aborted.\n\n"
                    puts "Returning to User Menu\n\n"
                    user_logged_in_menu
                    end
                else
                    system("clear")
                    puts "This Portfolio does not belong to you.\n\n"
                    puts "Returning to User Menu\n\n"
                    user_logged_in_menu
                end
        else
            system("clear")
            puts "Sorry, there is no portfolio with that ID.\n\n"
            puts "Returning to User Menu\n\n"
            user_logged_in_menu
        end
    when "Modify / Display User Info"
        system("clear")
        modify_user
    when "Return to Main Menu"
        system("clear")
        $active_user = nil
        main_menu
    end
end

def portfolio_menu
    puts "\n\n|---------PORTFOLIO MENU---------|\n\n".light_yellow.bold

    $active_portfolio.view_investments
    puts "\n\n"
    
    menu_options = ["Buy Stock", "Sell Stock", "Research Stock", "Return to User Menu"]
    input = $prompt.select("Please choose an option:", menu_options)
    case input
    when "Buy Stock"
        symbol_input = $prompt.ask("Please enter stock ticker symbol:")
        num_shares_input = $prompt.ask("Please enter number of shares to buy:")
        $active_portfolio.buy_stock(symbol_input, num_shares_input.to_f)
        system("clear")
        puts "\n\nBuy successful.\n\n"
        portfolio_menu
    when "Sell Stock"
        invest_id_input = $prompt.ask("Please enter investment ID:")
        num_shares_input = $prompt.ask("Please enter number of shares to sell:")
        if Investment.exists?(invest_id_input)
            if $active_portfolio.id == Investment.find(invest_id_input).portfolio_id 
                $active_portfolio.sell_stock_by_investment_id(invest_id_input.to_i, num_shares_input.to_i)
                portfolio_menu
            else
                puts "Investment does not belong to you.\n\n"
                puts "Returning to Portfolio Menu."
                portolio_menu
            end
        else
            system("clear")
            puts "Investment ID error.  Please try again.\n\n"
            portfolio_menu
        end
    when "Research Stock"
        symbol_input = $prompt.ask("Please enter stock ticker symbol:")
        if get_current_stock_data(symbol_input) == false
            system("clear")
            puts "\n\nSorry, that stock ticker symbol is invalid."
        else
            system("clear")
            puts "\n\n"
            get_current_stock_data(symbol_input).each {|key, value| puts "| #{key} | #{value}"}
        end
        portfolio_menu
    when "Return to User Menu"
        $active_portfolio = nil
        system("clear")
        user_logged_in_menu
    end
end

def modify_user
    puts "\n\n|---------MODIFY USER MENU---------|\n\n".light_yellow.bold
    puts "Current user details:\n\n"
    $active_user.display_information
    
    puts "\n\nModify User Info.  Username cannot be changed.\n\n"
    menu_options = ["Password", "First Name", "Last Name", "Email", "Delete User", "Return to User Menu"]
    input = $prompt.select("Which attribute would you like to edit:", menu_options)
    
    case input
    when "Password"
        password_input = $prompt.mask("Please enter new password:")
        $active_user.update(password: password_input)
        system("clear")
        puts "Password successfully updated.\n\n"
        puts "Returning to User Menu.\n\n"
        user_logged_in_menu
    when "First Name"
        first_name_input = $prompt.ask("Please enter first name:")
        $active_user.update(first_name: first_name_input)
        system("clear")
        puts "First name successfully updated.\n\n"
        puts "Returning to User Menu.\n\n"
        user_logged_in_menu
    when "Last Name"
        last_name_input = $prompt.ask("Please enter last name:")
        $active_user.update(last_name: last_name_input)
        system("clear")
        puts "Last name successfully updated.\n\n"
        puts "Returning to User Menu.\n\n"
        user_logged_in_menu
    when "Email"
        email_input = $prompt.ask("Please enter email address:") {|q| q.validate :email}
        $active_user.update(email: email_input)
        system("clear")
        puts "Email successfully updated.\n\n"
        puts "Returning to User Menu.\n\n"
        user_logged_in_menu
    when "Delete User"
        yes_no = $prompt.yes?("Are you sure?  This will permanently delete the user, all associated portfolios and investments.")
        if yes_no == true
            $active_user.delete_user
            $active_user = nil
            system("clear")
            puts "Returning to Main Menu.\n\n"
            main_menu
        else
            system("clear")
            puts "Delete aborted.\n\n"
            puts "Returning to Modify User Menu.\n\n"
            modify_user
        end
    when "Return to User Menu"
        system("clear")
        puts "\n\nReturning to User Menu.\n\n"
        user_logged_in_menu
    end
end
