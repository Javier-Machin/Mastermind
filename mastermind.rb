class Mastermind
  attr_accessor :secret_code #:feedback

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
    show_help
    puts EMPTY_SLOTS
    12.times do |index| 
      print "Enter your code attempt: "
      code_attempt = gets.chomp.downcase[0..3]
      feedback = @codemaker.check_attempt(code_attempt, @secret_code)
      update_board(code_attempt, feedback)
      puts @gameboard
      if game_over?(code_attempt)
      	puts "Codebreaker won!"
      	break
      elsif index == 11
      	puts "Codemaker won! the code was #{@secret_code}"
      end
    end
  end

  def start_cpu_vs_player
    @codemaker = Player.new
    @codebreaker = CpuPlayer.new
    @secret_code = @codemaker.generate_code
    code_attempt = @codebreaker.generate_attempt
    wrong_codes = []
    feedback = @codemaker.check_attempt(code_attempt, @secret_code)
    update_board(code_attempt, feedback)
    unless game_over?(code_attempt)
      11.times do
        wrong_codes << code_attempt
        code_attempt = @codebreaker.generate_attempt(code_attempt, feedback, wrong_codes)
        feedback = @codemaker.check_attempt(code_attempt, @secret_code)
        update_board(code_attempt, feedback)
        break if game_over?(code_attempt)
      end
    end
    puts @gameboard 
  end

  def game_over?(code_attempt)
    if code_attempt == @secret_code
      return true
    elsif code_attempt == "exit"
      return true
    else
      return false
    end
  end

  def show_help
    puts ''
    puts 'From left to right enter the first letter for each color. Example: rbgy'
    puts 'The code is 4 characters long and the possible colors are: r g b y w'
    puts 'There isn\'t any repeated color in the secret code '
    puts 'Each "o" next to your code means there is one color and placement correct'
    puts 'Each "x" next to your code means there is one color correct but with wrong placement'
    puts 'The position of every "o" and "x" doesn\'t relate to the code'
    puts '(it doesn\'t specify the slot that is correct or not)'
    puts 'Enter "exit" to leave the game'
    puts ''
  end

  def update_board(attempt,feedback)
  	attempt = attempt.split("")
  	@gameboard << "(#{attempt[0]}) (#{attempt[1]}) (#{attempt[2]}) (#{attempt[3]}) #{feedback}"
  	nil
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

    def generate_attempt(previous_attempt="",feedback="",wrong_codes=[])
      code = ""
      valid = false
      if feedback.length != 4
      	4.times do |index|
      	  while code.length != index + 1
      	    color = VALID_COLORS[rand(5)]
      	    code += color if !(code.include?(color))
          end
        end
        code
      elsif feedback.length == 4
      	while valid == false
      	  code = ""
      	  4.times do |index|
      	    while code.length != index + 1
      	      color = previous_attempt.split("")[rand(4)]
      	      code += color if !(code.include?(color))
            end
          end
          valid = true unless wrong_codes.any? {|wrong_code| code == wrong_code}
        end
        code
      end      
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
      #reverse the feedback so the player can't so easily deduce which color is correctly placed (it's easy anyway)
      return feedback.reverse.join("")  
    end
  end

  class Player < CpuPlayer

    def generate_code
      print "Enter a code for the CPU to guess: "
      code = gets.chomp.downcase[0..3] 
      while /[^rgbyw]/.match(code) || code.length < 4
        puts "The valid colors are: r g b y w"
        print "Enter a code for the CPU to guess: "
        code = gets.chomp.downcase[0..3] 
      end
      code
    end
  end
  
end

my_game = Mastermind.new
my_game.start_cpu_vs_player
#my_game.start_player_vs_cpu
