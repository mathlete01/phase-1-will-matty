require "pry"

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
    when "5"
      puts "Remember to Vote!"
      return
    when "exit"
      puts "Remember to Vote!"
      return
    else
      puts "#{input} is not a valid option "
      self.menu
    end
  end

  ################ Congress member methods ########################

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

  #Displays top 10 industries that gave member money and how much
  def display_congress_member_info(input, menu_hash)
    member = menu_hash.find { |key, value| key == input }.last
    puts
    puts "#{member.name}'s top 10 campaing contributing industries are:"
    self.get_industries_from_member(member).each_with_index do |donation, index|
      donation.each do |industry, amount|
        puts "#{index + 1}. #{industry}, #{amount}"
      end
    end
  end

  #Finds congress member by name, Not done yet!
  def find_congress_member_by_name
    puts
    puts "Enter congress member name:"
    name = gets.chomp
    puts
    ##### Fix this######
    member = CongressMember.find_by_name(name)
    #Catch instances where selected member doesn't exist
    if name.downcase == "exit"
      return
    elsif !member
      puts "#{name} is not a sitting member of congress. Please try again."
      self.find_congress_member_by_name
    else
      display_congress_member(member, index = nil)
    end
  end

  #display menu to get more info on members
  def more_info_on_member(menu_hash)
    puts
    puts "Select congress member or type home to return to the main menu"
    input = get_input_small
    input == "home" ? self.menu : self.display_congress_member_info(input, menu_hash)
  end

  #Outputs congress member data
  def display_congress_member(member, index = nil)
    info = "#{index} #{member.title} #{member.name},  #{member.party}"
    case member.party
    when "D"
      puts info.blue
    when "R"
      puts info.red
    else
      puts info
    end
  end

  ######################### General Helper Methods ###############
  def get_industries_from_member(member)
    industry_donations = []
    member.donations.each do |donation|
      industry_donations << { donation.industry.name => self.to_money(donation.amount) }
    end
    industry_donations
  end

  def to_money(amount)
    comas_added = amount.to_s.reverse.scan(/\d{3}|.+/).join(",").reverse
    "$#{comas_added}"
  end

  def get_input_big
    gets.chomp.upcase
  end

  def get_input_small
    gets.chomp.downcase
  end
end
