
logins = File.open("logins.txt", 'a') #Skapar en "logins.txt" fil 
logins.close

ALPHABET = "!?åäöabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" #Bokstäver

ENCODING = ")/=#(MOhqm0PnycUZeLdK8YvDCgNfb7FJtiHT52BrxoAkas9RWlXpEujSGI64VzQ31w" #Encyrpterings nyckel

def encode(text)
  text.tr(ALPHABET, ENCODING)
end

def load_logins()
  logins = File.readlines('logins.txt')

  logins.each_with_index do |user, i|
    logins[i] = user.chomp
  end
  
  logins.each_with_index do |user, i|
    @usernames << user.split(" ")[0]
    @passwords << user.split(" ")[1]
  end
end

logins = File.readlines('logins.txt')

@usernames = []
@passwords = []
@cash = 0


@logged_in = false

@logged_user = ""

logins.each_with_index do |user, i|
  logins[i] = user.chomp
end

logins.each_with_index do |user, i|
  @usernames << user.split(" ")[0]
  @passwords << user.split(" ")[1]
end


#LOGIN / SIGNIN Menus

def check_user(username, password)

  if @usernames.include?(username)
    if encode(password) == @passwords[@usernames.index(username)]
      @logged_in = true
      @logged_user = username
      p "Login successfull!"
    else
        puts "\e[H\e[2J"
      p "Wrong Username Or Password"
    end
  else
      puts "\e[H\e[2J"
    p "Wrong Username Or Password"
    
  end
end


def login_menu()

  puts "LOGIN MENU"
  puts "Enter USERNAME:"
  username_in = gets.chomp
  puts "Enter PASSWORD:"
  password_in = gets.chomp
  check_user(username_in, password_in)
end

def sign_up()
  p "SIGNIN MENU"
  p "Enter uniqe USERNAME:"
  username_in = gets.chomp
  if @usernames.include?(username_in)
    puts "\e[H\e[2J"
    p "There is alreade a user named #{username_in}"
    sign_up()
  else
    p "Enter PASSWORD"
    password_in = gets.chomp
    logins = File.open("logins.txt", 'a')
    logins.puts "\n#{username_in} #{encode(password_in)}"
    logins.close
    puts "\e[H\e[2J"
    p "SIGNUP completed. Login!"
    load_logins()
    login_menu()
  end
end

def menu()
  p "Login or Signup?"
  choice = gets.chomp.downcase
  login_menu() if choice == "login"
  sign_up() if choice == "signup"
end

###############

#Pengar Funktioner

def bank(user)
  load_cash()
  puts "\e[H\e[2J"
  ascii("bank")
  p "Welcome #{user} to your Bank"
  p "You currently have: #{@cash} $"
  p "Press enter to go back!"
  if gets == "\n"
    return ""
  end
  bank_append.close
end

def load_cash()
  bank_append = File.open("bank/#{@logged_user}.txt", 'a')
  bank_details = File.readlines("bank/#{@logged_user}.txt")
  bank_append.puts "80" if bank_details[0] == nil
  bank_append.close
  bank_details = File.readlines("bank/#{@logged_user}.txt")
  @cash = bank_details[0].chomp.to_i
end

def update_cash()
  bank_write = File.open("bank/#{@logged_user}.txt", 'w')
  bank_write.puts "#{@cash}"
  bank_write.close
end

def add_cash(amount)
  @cash += amount
  update_cash()
end

def remove_cash(amount)
  @cash -= amount
  update_cash()
end

############

#Casino Funktioner

def ascii(str)
  if str == "casino"
    puts "  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$ /$$   /$$  /$$$$$$ "
    puts " /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/| $$$ | $$ /$$__  $$"
    puts "| $$  \\__/| $$  \\ $$| $$  \\__/  | $$  | $$$$| $$| $$  \\ $$"
    puts "| $$      | $$$$$$$$|  $$$$$$   | $$  | $$ $$ $$| $$  | $$"
    puts "| $$      | $$__  $$ \\____  $$  | $$  | $$  $$$$| $$  | $$"
    puts "| $$    $$| $$  | $$ /$$  \\ $$  | $$  | $$\\  $$$| $$  | $$"
    puts "|  $$$$$$/| $$  | $$|  $$$$$$/ /$$$$$$| $$ \\  $$|  $$$$$$/"
    puts " \\______/ |__/  |__/ \\______/ |______/|__/  \\__/ \\______/ "
  elsif str == "bank"
    puts ".----------------.  .----------------.  .-----------------. .----------------. "
    puts "| .--------------. || .--------------. || .--------------. || .--------------. |"
    puts "| |   ______     | || |      __      | || | ____  _____  | || |  ___  ____   | |"
    puts "| |  |_   _ \\    | || |     /  \\     | || ||_   \\|_   _| | || | |_  ||_  _|  | |"
    puts "| |    | |_) |   | || |    / /\\ \\    | || |  |   \\ | |   | || |   | |_/ /    | |"
    puts "| |    |  __'.   | || |   / ____ \\   | || |  | |\\ \\| |   | || |   |  __'.    | |"
    puts "| |   _| |__) |  | || | _/ /    \\ \\_ | || | _| |_\\   |_  | || |  _| |  \\ \\_| |"
    puts "| |  |_______/   | || ||____|  |____|| || ||_____|\____|  | || | |____||____| | |"
    puts "| |              | || |              | || |              | || |              | |"
    puts "| '--------------' || '--------------' || '--------------' || '--------------' |"
    puts " '----------------'  '----------------'  '----------------'  '----------------' "
  end
end


def casino()
  puts "\e[H\e[2J"
  choice = ""
  ascii("casino")
  p "Welcome #{@logged_user} to the CASINO!!"
  p "Which gamemode would you like to play?"
  p "Coinflip, Dice, Roulette or press enter to quit"
  choice = gets.chomp.downcase

  if ["cj", "coinflip", "cflip"].include?(choice)
    choice = ""
    coinflip()
  elsif choice == "dice"
    choice = ""
    dice()
  elsif choice == "roulette"
    choice = ""
    roulette()
     
  elsif choice == "\n"
    choice = ""
    return ""
  end

end


#Dice Funktion
def dice()
  #Välkomst Text
  p "Welcome to dice!"
  p "You currently have: #{@cash}$"
  p "how much would you like to bet? (press enter to quit)"
  bet_amount = gets.chomp.to_i #Hur mycket spelaren vill betta

  if bet_amount > @cash || bet_amount < 0 #Kolla om man har tillräckligt med pengar och kolla om det är ett giltigt nummer
    p "Not sufficient balance or not valid number"
    puts "\e[H\e[2J"
    dice() #Om inte så startar man om dice
    return ""
  elsif bet_amount == 0 #Om man inte inputar något, så blir man tillbaka skickad till casino skärmen
    casino()
    return ""
  end

  p "choose number between 1-6"

  player_num = gets.chomp.to_i #Får in spelarens nummer

  if ![1,2,3,4,5,6].include?(player_num) #Kollar så att spelarens nummer är giltigt
    p "invalid  number!"
    puts "\e[H\e[2J"
    dice() #Startar om spelet om det inte är det
  end

  random_num = Random.rand(1..6) #Genererar en random siffra

  #Visulla delen av spelet
  sleep(1)
  print "\n"
  p "rolling dice!"
  sleep(1)
  print "\n"
  p "rolling dice!"
  sleep(1)
  print "\n"  
  p "IT LANDS ON #{random_num}"

  #Kollar om spelaren vunnit/förlorat.

  if player_num == random_num #Om vunnit, får spelaren 5gånger pengarna han lade in
    p "You WON! #{bet_amount*5}$"
    add_cash(bet_amount*5)
  else #Om förlorat
    p "You lost: #{bet_amount}$"
    remove_cash(bet_amount)
  end
  p "press enter to continue"
  if gets == "\n"
    puts "\e[H\e[2J"
    dice()
  end
end

def coinflip() #Hanterar Coinflip spelet returnerar inget
  p "Welcome to coinflip"
  p "You currently have: #{@cash}$"
  p "how much would you like to bet? (press enter to quit)"
  bet_amount = gets.chomp.to_i

  if bet_amount == 0 #Om inget bet placeras så skickas man tillbaka
    casino()
    return ""
  elsif bet_amount > @cash || bet_amount < 0
    puts "\e[H\e[2J"
    p "Not sufficient balance or not valid number"
    coinflip()
    return ""

  end

  #Spelaren väljer mellan heads eller tails
  p "choose heads or tails"
  player_in = gets.chomp
  if !["heads", "h", "tails", "t"].include?(player_in)
    puts "\e[H\e[2J"
    p "invalid  input"
    coinflip()
  end

  if ["heads", "h"].include?(player_in)
    player_in = 1
  elsif ["tails", "t"].include?(player_in)
    player_in = 2
  end

  #Random siffra (1eller2) väljs och den visuella delen av spelet körs igång
  random_num = Random.rand(1..2)
  print "\n"
  sleep(1)
  p "Flipping Coin!"
  print "\n"
  sleep(1)
  p "Flipping Coin"
  print "\n"
  sleep(1)
  p "Flipping Coin!"
  print "\n"  
  sleep(1)
  print "IT LANDS ON: "
  print "HEADS" if random_num == 1
  print "TAILS" if random_num == 2
  print("\n")

  #Utbetalning/Borttagning och updaterande av pengarna
  if player_in == random_num
    p "You WON! #{bet_amount}$"
    add_cash(bet_amount)
  else 
    p "You lost: #{bet_amount}$"
    remove_cash(bet_amount)
  end
  update_cash()
  p "press enter to continue"
  if gets == "\n"
    puts "\e[H\e[2J"
    coinflip()
  end
end

####################

# WORK

texts = ["it must've been love", "but its over now", "hallo? HALLO? HALLLOOO?", "Hej, jag heter Bogdan", "Vilket underbart spel detta är", "Ja må han leva, ja må han leva"]

def work() #Sköter work systemet, ingen return
  texts = ["it must've been love", "but its over now", "hallo? HALLO? HALLLOOO?", "Hej, jag heter #{@logged_user}", "Vilket underbart spel detta är", "Ja må han leva, ja må han leva", "#{@logged_user} is really beautiful", "Ska vi ut och strutsa?"] #de olika texterna
  p "Welcome to the job (press enter to quit)"
  p "You are a writer. You earn 25dollar per text"
  p "write the text:"
  current_text = texts[Random.rand(0..texts.length-1)] #Random text väljs
  print ("#{current_text}\n")
  user_text = gets.chomp
  if user_text == ""
    return ""
  end
  #Visuella delen
  p "CHECKING INPUT!"
  sleep(0.5)
  print("\n")
  print(".")
  sleep(0.5)
  print(".")
  sleep(0.5)
  print(".\n\n")
  sleep(0.5)
  #Kontrollerande av spelarens input och den randomiserade texten
  if current_text == user_text
    p "YOU WROTE CORRECTLY: you earned 25$" 
    add_cash(25)
    p "press enter to work again"
    if gets == "\n"
      puts "\e[H\e[2J"
      work()
    end
  else
    p"You wrote wrong!"
    p "press enter to try again"
    if gets == "\n"
      puts "\e[H\e[2J"
      work()
    end

  end

end

#########

def game() #Öppnar game.rb filen(Snake) och sköter det som den filen outputtar(score)
  puts "\e[H\e[2J"
  p "You are now playing Snake!"
  print "\n\n\n"
  score_output = `ruby game.rb`
  score = score_output.to_i
  p "You got the score #{score}, you earned #{score*5}$"
  add_cash(score*5)
  sleep(2)
  return ""
end

def roulette() #Öppnar roulette.rb filen(Roulette) och sköter sedan vad den outputtar("true" eller "false")
  puts "\e[H\e[2J"
  p "You are now playing Roulette"
  print "\n\n\n"
  p "How much do you want to bet?"
  bet = gets.chomp.to_i
  score_output = `ruby roulette.rb`
  score_output = score_output.chomp
  
  p "You Won" if score_output == "true"
  p "You Lost" if !score_output == "false"
  add_cash(bet) if score_output == "true"
  remove_cash(bet) if !score_output == "false"
  sleep(2)
  return ""


end

loop do #Spel loopen (Start Sidan)

  while @logged_in
    puts "\e[H\e[2J"
    load_cash()
    p "You are now logged in as #{@logged_user}"
    p "What would you like to access? Work | Bank | Casino | Game | Quit"
    choice = gets.chomp.downcase
    if choice == "quit"
      @logged_in = false
      break
    end

    if choice == "bank"
      bank(@logged_user)
    elsif choice == "casino"
      puts "\e[H\e[2J"
      casino()
    elsif choice == "work"
      puts "\e[H\e[2J"
      work()
    elsif choice == "game"
      game()
    end

  end
  menu()
end