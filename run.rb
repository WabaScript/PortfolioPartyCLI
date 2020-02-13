require_relative "./config/environment"

#-----Pre-run Data Load-----#
#Before demo run "Investment.update_all_prices_to_current_slowly_better"
#This will update all investment values to the current day value
#This only needs to be done once per day, but will take several minutes due to the 5 API calls per minute limit
#(Total number of investments / 5 minutes)

main_menu 

# binding.pry
0
