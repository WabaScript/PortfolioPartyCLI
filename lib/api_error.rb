class ApiError < StandardError
    def message
      "Our server is experiencing too many requests! Please wait one minute."
    end
  end