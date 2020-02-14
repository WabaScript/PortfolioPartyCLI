require_relative "./config/environment"

#-----Pre-run Data Load-----#
#Before demo, run "rake update_prices" in the terminal
#This will update all investment values to the current day value
#This only needs to be done once per day, but will take several minutes due to the 5 API calls per minute limit
#(Total number of investments / 5 minutes)
system("clear")

main_title

main_menu 

# binding.pry
0
