require "pry"

class CLI
  def initialize
<<<<<<< HEAD
    puts "     ___              ___      ___ ________  _________  _______             ___           "
    puts "    _|\\  \\__          |\\  \\    /  /|\\   __  \\|\\___   ___\\\\  ___ \\          _|\\  \\__      "
    puts "   |\\   ____\\         \\ \\  \\  /  / | \\  \\|\\  \\|___ \\  \\_\\ \\   __/|        |\\   ____\\     "
    puts "   \\ \\  \\___|_         \\ \\  \\/  / / \\ \\  \\\\\\  \\   \\ \\  \\ \\ \\  \\_|/__      \\ \\  \\___|_    "
    puts "    \\ \\_____  \\         \\ \\    / /   \\ \\  \\\\\\  \\   \\ \\  \\ \\ \\  \\_|\\ \\      \\ \\_____  \\    "
    puts "     \\|____|\\  \\         \\ \\__/ /     \\ \\_______\\   \\ \\__\\ \\ \\_______\\      \\|____|\\  \\   "
    puts "       ____\\_\\  \\         \\|__|/       \\|_______|    \\|__|  \\|_______|        ____\\_\\  \\  "
    puts "      |\\___    __\\                                                           |\\___    __\\ "
    puts "      \\|___|\\__\\_|                                                           \\|___|\\__\\_| "
    puts "           \\|__|                                                                  \\|__|       "

    puts "\nSenate-Vote Tracker"
    puts "=" * 45
=======
    puts "                                                         "
    puts "                                                       "
    puts "                                                  __     "
    puts "  ___ ___     ___     ___      __   __  __      /_\\ \\___ "
    puts "/\\'__` __`\\  / __`\\/\\' _ `\\ /\\'__`\\/\\ \\/\\ \\    /\\___  __\\"
    puts "/\\ \\/\\ \\/\\ \\/\\ \\L\\ \\/\\ \\/\\ \\/\\  __/\\ \\ \\_\\ \\   \\/__/\\_\\_/"
    puts "\\ \\_\\ \\_\\ \\_\\ \\____/\\ \\_\\ \\_\\ \\____\\/`____  \\      \\/_/ "
    puts " \\/_/\\/_/\\/_/\\/___/  \\/_/\\/_/\\/____/ `/___/> \\       "
    puts "                                        /\\___/           "
    puts "                                        \\/__/            "
    puts "               ___        __                             "
    puts "              /\\_ \\    __/\\ \\__  __                      "
    puts " _____     ___\\//\\ \\  /\\_\\ \\ ,_\\/\\_\\    ___    ____      "
    puts "/\\ \\__`\\  / __`\\\\ \\ \\ \\/\\ \\ \\ \\/\\/\\ \\  /\\'__\\/\\',__\\     "
    puts "\\ \\ \\L\\ \\/\\ \\L\\ \\\\_\\ \\_\\ \\ \\ \\ \\_\\ \\ \\/\\ \\__//\\__, `\\    "
    puts " \\ \\ ,__/\\ \\____//\\____\\\\ \\_\\ \\__\\\\ \\_\\ \\____\\/\\____/    "
    puts "  \\ \\ \\/  \\/___/ \\/____/ \\/_/\\/__/ \\/_/\\/____/\\/___/     "
    puts "   \\ \\_\\                                                 "
    puts "    \\/_/                                                 "
    puts "                                                          "
    puts "...see how they're connected"
    puts ""
>>>>>>> f76cc3d6b5f23a93dbf41cc9d8aee5110e815e3d
  end

  #Main menu would be nice to add some ascii
  def menu
    puts
    puts "-" * 60
    puts "Menu"
    puts "-" * 60
    puts "1. Start with a STATE"
    puts "2. Start with a SENATOR"
    puts "3. Start with an INDUSTRY"
    puts "4. EXIT"
    puts
    puts ">>> Enter your choice"
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
    when "exit"
      self.exit
    else
      puts "Sorry,  #{input} is not a valid option "
      self.menu
    end
  end

  ################ Congress member methods ########################

  #Gets inputs about state to then search for congress members
  def get_state_input
    puts
    puts ">>> Enter STATE as two-letter abbreviation"
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
    if members.empty?
      puts "Oops! #{state} is not a state"
      state = self.search_congress_by_location
    end

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
    puts "-" * 60
    if member.party == "D" 
      puts "Senator #{member.name.blue}'s top contributers by industry are:"
    elsif member.party == "R"
      puts "Senator #{member.name.red}'s top contributers by industry are:"
    end
    puts "-" * 60
    self.get_industries_from_member(member).each_with_index do |donation, index|
      donation.each do |industry, amount|
        industry_hash[(index + 1).to_s] = industry
        #puts "#{index + 1}. #{industry.name}, #{amount}"
        puts "#{index + 1}. #{amount}...#{industry.name}"
      end
    end
    puts
    puts ">>> Select an INDUSTRY above to see the senators it donated the most to"
    puts '(type "home" to return to the Main Menu)'
    input = get_input_small
    case input
    when "exit"
      return
    when "home"
      self.menu
    else
      self.get_members_from_industry(input, industry_hash)
      # For future development reasons
      # industry_choice = industry_hash[input]
      # create_bills_by_industry(industry_choice)
      # get_all_votes_by_politician(member)
      # self.votes_by_industry(member, industry_choice)
    end
  end

  #Finds congress member by name
  def find_congress_member_by_name
    puts
    puts ">>> Enter senator's FULL NAME:"
    name = gets.chomp
    puts
    ##### Fix this######
    formatted_name = name.split.map(&:capitalize).join(" ")
    member = CongressMember.find_by_name(formatted_name)
    #Catch instances where selected member doesn't exist
    if name.downcase == "exit"
      return
    elsif name == "home"
      self.menu
    elsif !member
      puts "Sorry, #{name} is not a sitting member of the senate. Please try again."
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
    puts ">>> Select a SENATOR above to see their top contributors by industry"
    puts '(type "home" to return to the Main Menu)'
    input = get_input_small
    if input == "exit"
      self.exit
    elsif input == "home"
      self.menu
    elsif !(1..menu_hash.length).to_a.include?(input.to_i)
      puts "Sorry, #{input} is not a valid option. Please try again."
      self.more_info_on_member(menu_hash)
    else
      self.display_congress_member_info(input, menu_hash)
    end
  end

  #Outputs congress member data
  def display_congress_member(member, index = nil)
    info = "#{index}. #{member.title} #{member.name}, #{member.party}–#{member.state}"
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

  def industry_donations_menu
    puts "\nTop campaign contributing industries and total amount contributed across all capmaigns in last election cycle"
    industry_hash = {}
    Industry.all.each_with_index do |industry, index|
      industry_hash[(index + 1).to_s] = industry
      donations = industry.donations.map(&:amount).sum
      donations = self.to_money(donations)
      puts "#{"#{index + 1}.".bold} #{donations}...#{industry.name}"
    end
    self.industry_donation_menu_selection(industry_hash)
  end

  def industry_donation_menu_selection(industry_hash)
    puts "\n >>> Select an INDUSTRY above to see how much they contributed to senators's re-election campaigns'"
    input = get_input_small

    # self.navigation(input, :get_members_from_industry, industry_hash)
    if input == "exit"
      self.exit
    elsif input == "home"
      self.menu
    elsif !(1..industry_hash.length).to_a.include?(input.to_i)
      puts "Sorry, #{input} is not a valid option. Please try again."
      self.industry_donation_menu_selection(industry_hash)
    else
      self.get_members_from_industry(input, industry_hash)
    end
  end

  # Lists all congress members that an industry has donated to
  def get_members_from_industry(input, industry_hash)
    industry = industry_hash.find { |index, industry| index == input }.last
    donations = industry.donations
    puts "-" * 60
    puts "#{industry.name} contributed the following amounts to these senators' campaigns"
    puts "-" * 60
    menu_hash = {}
    donations = donations.sort_by { |d| d.amount }.reverse
    donations.each_with_index do |donation, index|
      menu_hash[(index + 1).to_s] = donation.congress_member
      info = "#{index + 1}. #{to_money(donation.amount)}...#{donation.congress_member.name}, #{donation.congress_member.party}–#{donation.congress_member.state}"

      if donation.congress_member.party == "R"
        puts info.red
      elsif donation.congress_member.party == "D"
        puts info.blue
      else
        puts info
      end
    end
    self.member_select(menu_hash)
  end

  def member_select(menu_hash)
    puts "\n>>> Select a SENATOR above to see their top contributors by industry"
    puts '(type "home" to return to the Main Menu)'
    input = get_input_small

    if input == "exit"
      self.exit
    elsif input == "home"
      self.menu
    elsif !(1..menu_hash.length).to_a.include?(input.to_i)
      puts "Sorry, #{input} is not a valid option. Please try again."
      self.member_select(menu_hash)
    else
      self.display_congress_member_info(input, menu_hash)
    end
  end

  ##################### VOTE Methods ###############################

  #Fill in with sweet sweet code when we have data for votes and bills

  ######################### General Helper Methods ###############

  #Currently not working come back and fix this to DRY out code if time permits

  # def navigation(input, destination, params)
  #   case input
  #   when "exit"
  #     return
  #   when "home"
  #     self.menu
  #   else
  #     binding.pry
  #     method(destination(input, params)).call
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

  def exit
    Vote.destroy_all
    Bill.destroy_all 
    puts "#{"Thanks".red} #{"for".white} #{"playing".blue}, #{"and".white} #{"remember".red} #{"to".white} #{"Vote".blue}#{"!".white}"
    return
  end
end
