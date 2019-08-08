class PasswordManager

    def self.new_password(username,password)
        string = username + "" + password
        string = string.downcase
        Kernel.srand(codify(string))
        hash = generate
        return hash
    end

    def self.codify(string)
        primes = [2,3,5,7,11,13,17,19,23,31,37,41,43,47,51,53,61,67,71,73,83,91,97,101,103,107,109]
        alphabet = "abcdefghijklmnopqrstuvwxyz"
        nonprime = 0
        primevalue = 1
        string.length.times do |s|
            alphabet.length.times do |a|
                if string[s] == alphabet[a]
                    nonprime += a*primes[s%26]
                    primevalue *= primes[a]
                end
            end
        end
        return primevalue*nonprime
    end

    def self.generate
        alphabet = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        size = alphabet.length
        hash = ""
        20.times do 
            hash += alphabet[rand(size)]
        end
        return hash
    end
end