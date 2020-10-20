class CLI
  def initialize
    puts "Welcome to Politicians and money and stuff"
    puts "=" * 45
  end

  def menu
    puts
    puts "Main Menu"
    puts "-" * 30
    puts "1. Search for congress members by location"
    puts "2. Find congress members by name"
    puts "3. Search legislation by issue"
    puts "4. Search legislation by bill name"
    puts "5. Exit"
    puts
    puts "Enter your choice:"
    input = gets.chomp

    self.switch_board(input)
  end

  def switch_board(input)
    case input
    when "1"
      self.search_congress_by_location
    when "2"
      #Find_congress_member_by_name
    when "3"
      #search_legislation_by_issue
    when "4"
      #search_legislation_by_bill
    when "5"
      puts "Thanks for stopping by!"
      return
    else
      puts "#{input} is not a valid option "
      self.menu
    end
  end

  def search_congress_by_location
    puts
    puts "Enter state as two letter state code"
    state = gets.chomp.upcase
    puts
    #Mildly berrate the user for not following instructions
    if state.length > 2
      puts "#{state} is longer than 2 characters. Get it together"
      puts "Try again, but this time with only TWO letters"
      self.search_congress_by_location
    end
    #Find congress members
    members = CongressMember.all.select { |m| m.state }
    #display info on congress members
    members.each do |member|
      puts "#{member.name}  -  #{member.party}"
    end
  end
end
