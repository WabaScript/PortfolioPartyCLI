class User
    attr_accessor :id, :user_name, :password, :email
    attr_reader :name

    def initialize (id = nil)
        @user_name = user_name
        @id = id 
        @password = password
        @name = name
        @email = email
    end

    def self.create_user(name, user_name, password, email)
        new_user = User.new(name, user_name, password, email)
    end

    def name
        puts "#{name}"
    end

    
end