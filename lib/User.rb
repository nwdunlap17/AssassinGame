class User < ActiveRecord::Base
    attr_accessor :role, :links
    def self.create_new_user
        while true
            print "Enter your first name: "
            username = gets.chomp
            print "Enter your password: "
            hash1 = PasswordManager.new_password(username,gets.chomp)
            system('clear')
            print 'Enter your password again: '
            hash2 = PasswordManager.new_password(username,gets.chomp) 
            system('clear')

            if hash1 == hash2
                user = User.new
                user.name = username
                user.passhash = hash1
                user.save
                puts "User #{username} created!"
                return
            else
                puts"Those passwords did not match, please try again."
            end
        end
    end
end