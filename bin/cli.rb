require "pry"

class CLI
  def initialize
    clear
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
  end

  #Main menu would be nice to add some ascii
  def menu
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
    when "4"
      self.exit
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
    state
  end

  #Find conress members based on location, currently only works for states not zipcodes
  #Then calls display_congress_member to output infor on conress members
  def search_congress_by_location(error = nil)
    clear
    puts error
    state = self.get_state_input
    #find congress members
    members = CongressMember.all.select { |m| m.state == state }
    if state.downcase == "exit"
      self.exit
    elsif state.downcase == "home"
      self.menu
    elsif members.empty?
      error = "Sorry, #{state} is not a not a valid state code. Please try again."
      self.search_congress_by_location(error)
    else
      #display info on congress members
      menu_hash = {}
      members.each_with_index do |member, index|
        display_congress_member(member, (index + 1).to_s)
        #Build out a menu hash to respomnd to the users selection
        menu_hash[(index + 1).to_s] = member
      end

      self.more_info_on_member(menu_hash)
    end
  end

  #Displays top 10 industries that gave member money and how much
  def display_congress_member_info(input, menu_hash)
    clear
    industry_hash = {}
    member = menu_hash.find { |key, value| key == input }.last
    puts "-" * 60
    if member.party == "D"
      puts "Senator #{member.name.blue}'s top contributors by industry are:"
    elsif member.party == "R"
      puts "Senator #{member.name.red}'s top contributors by industry are:"
    else
      puts "Senator #{member.name.yellow}'s top contributors by industry are:"
    end
    puts "-" * 60
    self.get_industries_from_member(member).each_with_index do |donation, index|
      donation.each do |industry, amount|
        industry_hash[(index + 1).to_s] = industry
        puts "#{index + 1}. #{amount}...#{industry.name}"
      end
    end
    self.select_industry_from_congress_member(industry_hash)
  end

  def select_industry_from_congress_member(industry_hash)
    puts
    puts ">>> Select an INDUSTRY above to see the senators it donated the most to"
    puts '(type "home" to return to the Main Menu)'
    input = get_input_small
    if input == "exit"
      self.exit
    elsif input == "home"
      clear
      self.menu
    elsif !(1..industry_hash.length).to_a.include?(input.to_i)
      puts "Sorry, #{input} is not a valid option. Please try again."
      self.select_industry_from_congress_member(industry_hash)
    else
      self.get_members_from_industry(input, industry_hash)
    end
  end

  #Finds congress member by name
  def find_congress_member_by_name(error = nil)
    clear
    puts error
    puts ">>> Enter senator's FULL NAME:"
    name = gets.chomp
    puts
    formatted_name = name.split.map(&:capitalize).join(" ")
    member = CongressMember.find_by_name(formatted_name)
    #Catch instances where selected member doesn't exist
    if name.downcase == "exit"
      self.exit
    elsif name == "home"
      clear
      self.menu
    elsif !member
      error = "Sorry, #{name} is not a sitting member of the senate. Please try again."
      self.find_congress_member_by_name(error)
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
      clear
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
    #clear
    info = "#{index}. #{member.title} #{member.name}, #{member.party}–#{member.state}"
    case member.party
    when "D"
      puts info.blue
    when "R"
      puts info.red
    else
      puts info.yellow
    end
  end

  ################### Industry Methods ########################################
  #displays all industries and their contributions

  def industry_donations_menu
    puts "\nTop campaign contributing industries and total amount contributed across all capmaigns in last election cycle"
    clear
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
      clear
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
    clear
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
        puts info.yellow
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
      clear
      self.menu
    elsif !(1..menu_hash.length).to_a.include?(input.to_i)
      puts "Sorry, #{input} is not a valid option. Please try again."
      self.member_select(menu_hash)
    else
      self.display_congress_member_info(input, menu_hash)
    end
  end

  ######################### General Helper Methods ###############

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

  #clears out comand line
  def clear
    if Gem.win_platform?
      system "cls"
    else
      system "clear"
    end
  end

  def exit
    clear
    puts " ______  __                       __                     ___               "
    puts "/\\__  _\\/\\ \\                     /\\ \\                  /'___\\              "
    puts "\\/_/\\ \\/\\ \\ \\___      __      ___\\ \\ \\/'\\     ____    /\\ \\__/  ___   _ __  "
    puts "   \\ \\ \\ \\ \\  _ `\\  /'__`\\  /' _ `\\ \\ , <    /',__\\   \\ \\ ,__\\/ __`\\/\\`'__\\"
    puts "    \\ \\ \\ \\ \\ \\ \\ \\/\\ \\L\\.\\_/\\ \\/\\ \\ \\ \\\\`\\ /\\__, `\\   \\ \\ \\_/\\ \\L\\ \\ \\ \\/ "
    puts "     \\ \\_\\ \\ \\_\\ \\_\\ \\__/.\\_\\ \\_\\ \\_\\ \\_\\ \\_\\/\\____/    \\ \\_\\\\ \\____/\\ \\_\\ "
    puts "      \\/_/  \\/_/\\/_/\\/__/\\/_/\\/_/\\/_/\\/_/\\/_/\\/___/      \\/_/ \\/___/  \\/_/ "
    puts "                                                                           "
    puts "                                                                           "
    puts "       ___                                         __     "
    puts "      /\\_ \\                     __                /\\ \\    "
    puts " _____\\//\\ \\      __     __  __/\\_\\    ___      __\\ \\ \\   "
    puts "/\\ '__`\\\\ \\ \\   /'__`\\  /\\ \\/\\ \\/\\ \\ /' _ `\\  /'_ `\\ \\ \\  "
    puts "\\ \\ \\L\\ \\\\_\\ \\_/\\ \\L\\.\\_\\ \\ \\_\\ \\ \\ \\/\\ \\/\\ \\/\\ \\L\\ \\ \\_\\ "
    puts " \\ \\ ,__//\\____\\ \\__/.\\_\\\\/`____ \\ \\_\\ \\_\\ \\_\\ \\____ \\/\\_\\"
    puts "  \\ \\ \\/ \\/____/\\/__/\\/_/ `/___/> \\/_/\\/_/\\/_/\\/___L\\ \\/_/"
    puts "   \\ \\_\\                     /\\___/             /\\____/   "
    puts "    \\/_/                     \\/__/              \\_/__/    "
    puts "\n#{"Thanks".red} #{"for".white} #{"playing".blue}, #{"and".white} #{"remember".red} #{"to".white} #{"Vote".blue}#{"!".white}"
    return
  end
end
