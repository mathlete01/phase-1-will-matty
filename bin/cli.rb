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
    puts "3. Search legislation by industry"
    puts "4. Exit"
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
      self.industry_donations_menu
    when "5"
      puts "Remember.red to Vote!"
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
    industry_hash = {}
    member = menu_hash.find { |key, value| key == input }.last
    get_all_votes_by_politician(member)
    puts "#{member.name}'s top 10 campain contributing industries are:"
    puts "-" * 45
    self.get_industries_from_member(member).each_with_index do |donation, index|
      donation.each do |industry, amount|
        industry_hash[(index + 1).to_s] = industry
        puts "#{index + 1}. #{industry.name}, #{amount}"
      end
    end
    puts
    puts "Select an industry to see how #{member.name} has voted on bills relating to this industry"
    puts 'or type "home" to return to the main menu.'
    input = get_input_small
    #  self.navigation(input, self.votes_by_industry, industry_hash)
    case input
    when "exit"
      return
    when "home"
      self.menu
    else
      industry_choice = industry_hash[input]
      self.votes_by_industry(industry_choice)
    end
  end

  #Finds congress member by name
  def find_congress_member_by_name
    puts
    puts "Enter congress member name:"
    name = gets.chomp
    puts
    ##### Fix this######
    formatted_name = name.split.map(&:capitalize).join(" ")
    member = CongressMember.find_by_name(formatted_name)
    #Catch instances where selected member doesn't exist
    if name.downcase == "exit"
      return
    elsif name == "back"
      self.menu
    elsif !member
      puts "#{name} is not a sitting member of congress. Please try again."
      self.find_congress_member_by_name
    else
      #Becuase we are only returning one Congress memeber index = 1
      index = "1"
      self.display_congress_member(member, index)
      menu_hash = { index => member }
      self.more_info_on_member(menu_hash)
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
    info = "#{index}. #{member.title} #{member.name},  #{member.party}"
    case member.party
    when "D"
      puts info.blue
    when "R"
      puts info.red
    else
      puts info
    end
  end

  ################### Industry Methods ########################################
  #displays all industries and their contributions

  def votes_by_industry(industry_obj)
    create_bills_by_industry(industry_obj)
    #Make API call for bills realted to in industry.name and display bills with voting records.
  end

  # def votes_by_industry(input, industry_hash)
  #   industry = industry_hash.find { |index, industry| index == input }.last
  #   puts "Here we will put info on the members voting record on all bills for a given industry"
  #   binding.pry
  #   #Make API call for bills realted to in industry.name and display bills with voting records.
  # end

  def industry_donations_menu
    puts "\nTop campaign contributing industries and total amount contributed across all capmaigns in last election cycle"
    industry_hash = {}
    Industry.all.each_with_index do |industry, index|
      industry_hash[(index + 1).to_s] = industry
      donations = industry.donations.map(&:amount).sum
      donations = self.to_money(donations)
      puts "#{index + 1}. #{industry.name}, #{donations}"
    end
    puts "\n Select industry to see which congress members received contributions"
    input = get_input_small

    if input == "exit"
      return
    elsif input == "home"
      self.menu
    else
      self.get_members_from_industry(input, industry_hash)
    end
  end

  def get_members_from_industry(input, industry_hash)
    industry = industry_hash.find { |index, industry| index == input }.last
    donations = industry.donations
    puts "#{industry.name} gave to the following congress members in the last election cycle"
    puts "-" * 30
    donations.each_with_index do |donation, index|
      if donation.congress_member.party == "R"
        puts "#{index + 1}. #{donation.congress_member.name}, #{to_money(donation.amount)}".red
      elsif donation.congress_member.party == "D"
        puts "#{index + 1}. #{donation.congress_member.name}, #{to_money(donation.amount)}".blue
      else
        puts "#{index + 1}. #{donation.congress_member.name}, #{to_money(donation.amount)}".red
      end
    end
  end

  ######################### General Helper Methods ###############

  # def navigation(input, destination, params)
  #   case input
  #   when "exit"
  #     return
  #   when "home"
  #     self.menu
  #   else
  #     destination(input, params)
  #   end
  # end

  def get_industries_from_member(member)
    industry_donations = []
    member.donations.each do |donation|
      industry_donations << { donation.industry => self.to_money(donation.amount) }
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
