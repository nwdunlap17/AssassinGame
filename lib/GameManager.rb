class GameManager

    def initialize
        Kernel.srand(21)
        #Kernel.srand(Time.now.day+Time.now.month*100)
        @players = User.all
        @players.each do |player|
            player.role = "none"
            player.target = nil
        end
        #assign_assassin_roles
        assign_team_roles
    end

    def assign_assassin_roles
        count = @players.length
        get_random_player_of_type("none").role = "FBI Agent"
        3.times do 
            target = get_random_player_of_type("none")
            target.role = "Target"
            assassin = get_random_player_of_type("none")
            assassin.role = "Assassin"
            assassin.target = target.name
        end
    end

    def assign_team_roles
        count = @players.length
        @players.each do |player|
            player.role = "Innocent"
        end
        get_random_player_of_type("Innocent").role = "Martyr" 
        traitor1 = get_random_player_of_type("Innocent")
        traitor1.role = "Traitor"
        traitor2 = get_random_player_of_type("Innocent")
        traitor2.role = "Traitor"
        traitor1.target = traitor2.name
        traitor2.target = traitor1.name
    end

    def get_random_player_of_type(required_role = "none")
        chosen_player = nil
        while !!!chosen_player
            randval = rand(@players.length)
            if @players[randval].role == required_role
                chosen_player = @players[randval]
            end
        end
        return chosen_player
    end

    def get_role
        puts "Enter name: "
        name = gets.chomp
        puts "Enter password: "
        hash = PasswordManager.new_password(name,gets.chomp)
        you = @players.find do |player|
            player.passhash == hash
        end

        case you.role
        when "none"
            puts "something went wrong!"
        when "Assassin"
            puts "You're an Assassin!"
            puts "You win if your target is dead at the end of the game and you're alive."
            if Time.now.hour >= 12 && Time.now.minute >= 30
                puts "Your target is #{you.target.name}"
            else
                puts "Your target will be revealed at 12:30"
            end
        when "FBI Agent"
            puts "You're an FBI Agent, you win if most of the targets are alive at the end of the game."
            puts "If someone shoots you, they're dead too!"
        when "Target"
            puts "Someone is hunting you!"
            puts "You win if you are still alive at the end of the game"
        when "Innocent"
            puts "You're Innocent! You win if you're still alive at the end of the game"
        when "Traitor"
            puts "You're a Traitor! You win if all non-traitors are dead at the end of the game"
            puts "Your ally is #{you.target}."
        when "Martyr"
            puts "You're a Martyr! You win if you are killed by an Innocent!"
            puts "If you shoot anyone, you lose and you're out. (but you can still miss on purpose!)"
            puts "If you are killed, reveal that you're the Martyr. Your killer must reveal their role."
        end
    end
end