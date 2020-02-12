
def symbol_validate (input)
    url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=#{input}&apikey=4NRHKKZWK1U7T0P1"
    response = RestClient.get(url)
    my_response = JSON.parse(response)
    if my_response["Error Message"] == nil
        true
    else
        false
    end
end