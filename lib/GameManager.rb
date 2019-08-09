class GameManager

    def initialize(seed=(Time.now.day+Time.now.month*100))
        #Kernel.srand(22)
        Kernel.srand(seed)
        @players = User.all
        @players.each do |player|
            player.role = "none"
            player.links = []
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
            assassin.links << target.name
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
        terrorist1.links << terrorist2.name
        terrorist2.links << terrorist1.name

        @detective = get_random_player_of_type("Innocent")

        @detective.role = "Detective"
        @suspect = get_random_player_of_type("Terrorist")
        @innocent = get_random_player_of_type("Innocent")
        acceptable = false
        randval = -100
        while acceptable == false
            randval = rand(@players.length)+1
            acceptable = true 
            if @suspect.id == randval || @innocent.id == randval || @detective.id == randval
                acceptable = false
                puts @suspect.id
                puts @innocent.id
                puts randval
            end
        end
        @detective.links << @suspect.name
        @detective.links << @innocent.name
        @detective.links << @players[randval-1].name
        @detective.links = @detective.links.shuffle
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
                puts "Your target is #{you.links[0].name}"
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
        when "Detective"
            puts "You're Innocent! You win if any Innocents are still alive at the end of the game"
            puts "At least one person below is a Terrorist, and at least one person below is an Innocent"
            you.links.each do |person|
                puts "#{person}"
            end
        when "Terrorist"
            puts "You're a Terrorist! You win if all Innocents are dead at the end of the game"
            puts "Your ally is #{you.links[0]}."
        when "Martyr"
            puts "You're a Martyr sympathetic to the Terrorist cause!" 
            puts "Get killed unprovoked by an Innocent to win!"
            puts "YOU WIN IF YOU ARE KILLED BY AN INNOCENT."
            puts "YOU LOSE IF YOU FIRE A GUN, OR DO NOT GET KILLED BY AN INNOCENT."
        end
    end

    def team_rules
        puts"Rules:"
        puts"If you are hit with a bullet, you are out. Announce your role, but you may not tell anyone who shot you."
        puts"Bullets must be fired from a gun. If a bullet hits an object you're holding, you're out."
        puts"Terrorists:"
        puts"There are 2 Terrorists. They know who eachother are. They want every innocent dead before the end of the game(end of lunch)"
        puts"Innocents:"
        puts"There are 5 Innocents, they win if ANY Innocent is alive at the end of the game (end of lunch)"
        puts"One Innocent is a Detective, they get a list of 3 suspects, they know one is a terrorist and one is innocent, but not who is who."
        puts"Martyr:"
        puts"There is one Martyr. If an Innocent shoots the martyr, the Innocent dies and the Martyr wins."
        puts"If a terrorist shoots the Martyr, the terrorist must reveal their role"
        puts"The Martyr loses if they fire a gun"
    end
end