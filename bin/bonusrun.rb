require_relative '../config/environment.rb'
puts "Enter seed:"
Kernel.srand(gets.chomp.to_i)
game = GameManager.new(rand(10000))
game.get_role