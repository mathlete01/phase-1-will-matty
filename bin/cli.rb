class CLI
  def initialize
    puts "Welcome to Politicians and money and stuff"
    puts "=" * 45
  end

  #Main menu would be nice to add some ascii
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
    input = get_input_small

    self.main_switch_board(input)
  end

  #Logic for directing main menu inputs
  def main_switch_board(input)
    case input
    when "1"
      self.search_congress_by_location
    when "2"
      self.find_congress_member_by_name
    when "3"
      #search_legislation_by_issue
    when "4"
      #search_legislation_by_bill
    when "5" || "exit"
      puts "Remember to Vote!"
      return
    else
      puts "#{input} is not a valid option "
      self.menu
    end
  end

  #method will be used to dispaly inforamtion about congressmembers voting and fincanctial records
  def display_congress_member_info(input, menu_hash)
    member = menu_hash.find { |key, value| key == input }.last
    puts "more info on voting record!"
  end

  #Find conress members based on location, currently only works for states not zipcodes
  #Then calls display_congress_member to output infor on conress members
  def search_congress_by_location
    state = self.get_state_input
    #Find congress members
    members = CongressMember.all.select { |m| m.state == state }
    #display info on congress members
    menu_hash = {}
    members.each_with_index do |member, index|
      display_congress_member(member, (index + 1).to_s)
      #Build out a menu hash to respomnd to the users selection
      menu_hash[(index + 1).to_s] = member
    end
    self.more_info_on_member(menu_hash)
  end

  #Finds congress member by name, Not done yet!
  def find_congress_member_by_name
    puts
    puts "Enter congress member name:"
    name = get_input_small
    puts
    ##### Fix this######
    member = CongressMember.all.find_by_name(name)
    display_congress_member(member, index = nil)
  end

  #Gets inputs about state to then search for congress members
  def get_state_input
    puts
    puts "Enter state as two letter state code"
    state = get_input_big
    puts
    #Mildly berrate the user for not following instructions
    if state.length > 2
      puts "#{state} is longer than 2 characters. Get it together!"
      puts "Try again, but this time with only TWO letters"
      self.get_state_input
    end
    state
  end

  #Outputs congress member data
  def display_congress_member(member, index = nil)
    puts "#{index} #{member.title} #{member.name},  #{member.party}"
  end

  def get_input_big
    gets.chomp.upcase
  end

  def get_input_small
    gets.chomp.downcase
  end

  #display menu to get more info on members
  def more_info_on_member(menu_hash)
    puts
    puts "Select congress member or type home to return to the main menu"
    input = get_input_small
    input == "home" ? self.menu : self.display_congress_member_info(input, menu_hash)
  end
end
