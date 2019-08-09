class GameManager

    def initialize(seed=(Time.now.day+Time.now.month*100))
        #Kernel.srand(21)
        Kernel.srand(seed)
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
        @terrorist_number = @players.length/3
        @players.each do |player|
            player.role = "Innocent"
        end
        get_random_player_of_type("Innocent").role = "Martyr" 
        terrorist1 = get_random_player_of_type("Innocent")
        terrorist1.role = "Terrorist"
        terrorist2 = get_random_player_of_type("Innocent")
        terrorist2.role = "Terrorist"
        terrorist1.target = terrorist2.name
        terrorist2.target = terrorist1.name
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
        system('clear')
        team_rules
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
            puts "You're Innocent! You win if any Innocents are still alive at the end of the game"
        when "Terrorist"
            puts "You're a Terrorist! You win if all Innocents are dead at the end of the game"
            puts "Your ally is #{you.target}."
        when "Martyr"
            puts "You're a Martyr! You win if you are killed by an innocent!"
            puts "You're not allowed to shoot a gun. (but feel free to wave it around threateningly)"
            puts "When you are killed, your killer must reveal their role. If they are innocent, they're out!"
        end
    end

    def team_rules
        puts"Rules:"
        puts"There are 2 Terrorists and 1 Martyr, everyone else is Innocent."
        puts"Both terrorists knows who the other terrorist is."
        puts"The Terrorists want to kill all the innocents"
        puts"The Innocents want at least one innocent alive."
        puts"The Martyr wants to be shot by an innocent."
        puts"If you are hit by a shot, you are out. Announce your role, but you may not tell anyone who shot you."
        puts""
    end
end