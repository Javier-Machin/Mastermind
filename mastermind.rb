class Mastermind
  attr_accessor :secret_code

  EMPTY_SLOTS = "( ) ( ) ( ) ( )"
  VALID_COLORS = ["r", "g", "b", "y", "w"]
 
  def initialize
  	@codemaker = CpuPlayer.new
  	@codebreaker = Player.new
  	@gameboard = []
  	@secret_code = ""
  end

  def start_player_vs_cpu
    @secret_code = @codemaker.generate_code
    puts secret_code
    show_help
    puts EMPTY_SLOTS
    print "Enter your code attempt: "
    @code_attempt = gets.chomp.downcase[0..3]
    @gameboard << @codemaker.check_attempt(@code_attempt, @secret_code)
    puts @gameboard
    puts EMPTY_SLOTS
  end

  def show_help
  	puts ""
    puts 'From left to right enter the first letter for each color. Example: rbgy '
    puts 'The code is 4 characters long and the possible colors are: r g b y w '
    puts 'There isn\'t any repeated color in the secret code '
    puts 'Each "o" next to your code means there is one color and placement correct '
    puts 'Each "x" next to your code means there is one color correct but with wrong placement '
    puts 'The position of every "o" and "x" doesn\'t relate to the code '
    puts '(it doesn\'t specify the slot that is correct or not)'
    puts ""
  end

  class CpuPlayer
    
    def generate_code
      code = ""	
      4.times do |index|
      	while code.length != index + 1
      	color = VALID_COLORS[rand(5)]
      	code += color if !(code.include?(color))
        end
      end
      code
    end

    def check_attempt(attempt, secret_code)
      feedback = []
      attempt = attempt.split("")
      attempt.each_with_index do |color, index|
        if color == secret_code[index]
          feedback << "o"
        elsif secret_code.include?(color)
          feedback << "x"
        end
      end
      #reverse the feedback before returning it so the player can't easily deduce which color is correctly placed
      feedback = feedback.reverse.join("") 
      "(#{attempt[0]}) (#{attempt[1]}) (#{attempt[2]}) (#{attempt[3]}) #{feedback}"
    end
  end

  class Player

  end

end

my_game = Mastermind.new
my_game.start_player_vs_cpu
